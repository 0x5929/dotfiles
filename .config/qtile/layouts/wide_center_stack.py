# from libqtile.layout import base
# from libqtile.log_utils import logger
#
#
# class WideCenterStack(base.Layout):
#     defaults = [
#         ("border_width", 5, "Window border width"),
#         ("border_colour", "#8be9fd", "Window border colour"),
#         ("margin", 0, "Margin of layout"),
#     ]
#
#     def __init__(self, **config):
#         base.Layout.__init__(self, **config)
#         self.add_defaults(WideCenterStack.defaults)
#         self.clients = []
#         self.current_client = None
#
#     def configure(self, client, screen_rect):
#         try:
#             index = self.clients.index(client)
#             windows = 0 if index > 0 else 1
#         except ValueError:
#             # Layout not expecting this window so ignore it
#             return
#
#         quarters = [
#             (0, 0),
#             (0.8, 0),
#         ]
#
#         xpos, ypos = quarters[windows]
#
#         x = int(screen_rect.width * xpos) + screen_rect.x
#         y = int(screen_rect.height * ypos) + screen_rect.y
#         w = (
#             int(0.8 * screen_rect.width)
#             if windows == 0
#             else int(0.2 * screen_rect.width)
#         )
#         h = screen_rect.height
#
#         logger.exception(f"x, {x}")
#         logger.exception(f"y, {y}")
#         logger.exception(f"w, {w}")
#         logger.exception(f"h, {h}")
#         logger.exception(f"screen_rect.width {screen_rect.width}")
#         logger.exception(f"screen_rect.height {screen_rect.height}")
#         client.place(
#             x,
#             y,
#             w - self.border_width * 2,
#             h - self.border_width * 2,
#             self.border_width,
#             self.border_colour,
#             margin=0,
#         )
#
#     def add_client(self, client):
#         self.clients.insert(0, client)
#         self.current_client = client
#
#     def focus_first(self):
#         if not self.clients:
#             return None
#
#         return self.client[0]
#
#     def focus_last(self):
#         if not self.clients:
#             return None
#
#         return self.client[-1]
#
#     def focus_next(self, client):
#         try:
#             return self.clients[self.clients.index(client) + 1]
#         except IndexError:
#             return None
#
#     def focus_previous(self, client):
#         if not self.clients or self.clients.index(client) == 0:
#             return None
#
#         try:
#             return self.clients[self.clients.index(client) - 1]
#         except IndexError:
#             return None
#
#     def next(self):
#         if self.current_client is None:
#             return
#         # Get the next client or, if at the end of the list, get the first
#         client = self.focus_next(self.current_client) or self.focus_first()
#         self.group.focus(client, True)
#
#     def previous(self):
#         if self.current_client is None:
#             return
#         # Get the previous client or, if at the end of the list, get the last
#         client = self.focus_previous(self.current_client) or self.focus_last()
#         self.group.focus(client, True)
#
#     def remove(self, client):
#         if client not in self.clients:
#             return None
#         elif len(self.clients) == 1:
#             self.clients.remove(client)
#             self.current_client = None
#
#             return None
#         else:
#             index = self.clients.index(client)
#             self.clients.remove(client)
#             index %= len(self.clients)
#             next_client = self.clients[index]
#             self.current_client = next_client
#             return next_client
