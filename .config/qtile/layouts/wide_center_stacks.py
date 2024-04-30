from libqtile import layout
from libqtile.command.base import expose_command
from libqtile.layout.base import Layout, _ClientList
from libqtile.log_utils import logger


class _WinStack(_ClientList):
    # no split in this version of helper
    cw = _ClientList.current_client

    def __init__(self, autosplit=False):
        _ClientList.__init__(self)

    def __str__(self):
        return "_WinStack: %s, %s" % (
            self.cw,
            # str([client.name for client in self.clients]),
        )

    @expose_command()
    def info(self):
        return _ClientList.info(self)


# editted from qtile stack layout source code
class WideCenterStack(Layout):
    defaults = [
        # changed border color
        ("border_focus", "#8be9fd", "Border colour(s) for the focused window."),
        ("border_normal", None, "Border colour(s) for un-focused windows."),
        (
            "border_focus_stack",
            None,
            "Border colour(s) for the focused stacked window. If 'None' will \
         default to border_focus.",
        ),
        (
            "border_normal_stack",
            None,
            "Border colour(s) for un-focused stacked windows. If 'None' will \
         default to border_normal.",
        ),
        ("border_width", 1, "Border width."),
        ("autosplit", False, "Auto split all new stacks."),
        ("num_stacks", 2, "Number of stacks."),
        ("margin", 0, "Margin of the layout (int or list of ints [N E S W])"),
    ]

    def __init__(self, **config):
        Layout.__init__(self, **config)
        self.add_defaults(WideCenterStack.defaults)

        # change from stack, only two allowed
        if self.num_stacks != 2:
            self.num_stacks = 2
        self.stacks = [
            _WinStack(autosplit=self.autosplit) for i in range(self.num_stacks)
        ]

    @property
    def current_stack(self):
        return self.stacks[self.current_stack_offset]

    @property
    def current_stack_offset(self):
        for i, s in enumerate(self.stacks):
            if self.group.current_window in s:
                return i
        return 0

    @property
    def clients(self):
        client_list = []
        for stack in self.stacks:
            client_list.extend(stack.clients)
        return client_list

    # def clone(self, group):
    #     pass

    def _find_next(self, lst, offset):
        for i in lst[offset + 1 :]:
            if i:
                return i
        for i in lst[:offset]:
            if i:
                return i

    def delete_current_stack(self):
        if len(self.stacks) > 1:
            off = self.current_stack_offset or 0
            s = self.stacks[off]
            self.stacks.remove(s)
            off = min(off, len(self.stacks) - 1)
            self.stacks[off].join(s, 1)
            if self.stacks[off]:
                self.group.focus(self.stacks[off].cw, False)

    def next_stack(self):
        n = self._find_next(self.stacks, self.current_stack_offset)
        if n:
            self.group.focus(n.cw, True)

    def previous_stack(self):
        n = self._find_next(
            list(reversed(self.stacks)),
            len(self.stacks) - self.current_stack_offset - 1,
        )
        if n:
            self.group.focus(n.cw, True)

    def focus(self, client):
        for i in self.stacks:
            if client in i:
                i.focus(client)

    def focus_first(self):
        if self.stacks:
            return self.stacks[0].focus_first()
        return None

    def focus_last(self):
        if self.stacks:
            return self.stacks[-1].focus_last()
        return None

    def focus_next(self, client):
        iterator = iter(self.stacks)
        for i in iterator:
            if client in i:
                if next_ := i.focus_next(client):
                    return next_
                break
        else:
            return None

        if i := next(iterator, None):
            return i.focus_first()
        return None

    def focus_previous(self, client):
        iterator = reversed(self.stacks)
        for i in iterator:
            if client in i:
                if nxt := i.focus_previous(client):
                    return nxt
                break
        else:
            return None

        if i := next(iterator, None):
            return i.focus_last()
        return None

    def add_client(self, client):
        for i in self.stacks:
            if self.group.current_window not in i:
                i.add_client(client)
                return
        self.current_stack.add_client(client)

    def remove(self, client):
        current_offset = self.current_stack_offset
        for i in self.stacks:
            if client in i:
                i.remove(client)
                break
        if self.stacks[current_offset].cw:
            return self.stacks[current_offset].cw
        else:
            n = self._find_next(
                list(reversed(self.stacks)), len(self.stacks) - current_offset - 1
            )
            if n:
                return n.cw
        return None

    def configure(self, client, screen_rect):
        # pylint: disable=undefined-loop-variable
        # We made sure that self.stacks is not empty, so s is defined.
        for i, s in enumerate(self.stacks):
            if client in s:
                break
        else:
            client.hide()
            return

        if client.has_focus:
            if self.border_focus_stack:
                if s.split:
                    px = self.border_focus
                else:
                    px = self.border_focus_stack
            else:
                px = self.border_focus
        else:
            if self.border_normal_stack:
                if s.split:
                    px = self.border_normal
                else:
                    px = self.border_normal_stack
            else:
                px = self.border_normal

        # OVERRIDING DEFAULT
        big_window = True if self.clients.index(client) == 0 else False
        ratio = 0.8

        column_width = (
            int(screen_rect.width * ratio)
            if big_window
            else int(screen_rect.width * (1 - ratio))
        )
        xoffset = (
            int(0 + int(screen_rect.x))
            if big_window
            else int(int(screen_rect.width * ratio) + int(screen_rect.x))
        )

        window_width = column_width - 2 * self.border_width

        if client == s.cw:
            client.place(
                xoffset,
                screen_rect.y,
                window_width,
                screen_rect.height - 2 * self.border_width,
                self.border_width,
                px,
                margin=self.margin,
            )
            client.unhide()
        else:
            client.hide()

    @expose_command()
    def info(self):
        d = Layout.info(self)
        d["stacks"] = [i.info() for i in self.stacks]
        d["current_stack"] = self.current_stack_offset
        d["clients"] = [c.name for c in self.clients]
        return d

    @expose_command()
    def toggle_split(self):
        pass

    @expose_command()
    def down(self):
        self.current_stack.current_index += 1
        self.group.focus(self.current_stack.cw, False)

    @expose_command()
    def up(self):
        self.current_stack.current_index -= 1
        self.group.focus(self.current_stack.cw, False)

    @expose_command()
    def shuffle_up(self):
        self.current_stack.shuffle_up()
        self.group.layout_all()

    @expose_command()
    def shuffle_down(self):
        self.current_stack.shuffle_down()
        self.group.layout_all()

    @expose_command()
    def delete(self):
        self.delete_current_stack()

    @expose_command()
    def next(self):
        return self.next_stack()

    @expose_command()
    def previous(self):
        self.previous_stack()

    @expose_command()
    def client_to_next(self):
        return self.client_to_stack(self.current_stack_offset + 1)

    @expose_command()
    def client_to_previous(self):
        return self.client_to_stack(self.current_stack_offset - 1)
