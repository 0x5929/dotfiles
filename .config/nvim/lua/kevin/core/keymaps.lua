vim.g.mapleader = " "

local keymap = vim.keymap

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- search
keymap.set("n", "<C-f>", "/\\c", { desc = "Clear search highlights" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- replace
-- keymap.set("x", "<leader>r", ":s///gc<Left><Left><Left>", {
-- 	desc = "Search and replace in selection",
-- })

-- save document
keymap.set("n", "<A-s>", ":w<CR>", { desc = "Save current buffer" })

-- redraw syntax
keymap.set("n", "<F12>", "<cmd>syn sync fromstart<CR>", { desc = "resync syntax" })

-- tabs
keymap.set("n", "<A-t>", "<cmd>tabnew<CR>", { desc = "Open new tab", noremap = true }) -- open new tab
keymap.set("n", "<A-w>", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<A-n>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<A-p>", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<A-o>", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

local ok, visual_replace = pcall(require, "kevin.core.visual_replace")
if ok and visual_replace and type(visual_replace.setup) == "function" then
	visual_replace.setup()
else
	vim.notify("kevin.core.visual_replace not loaded", vim.log.levels.WARN)
end
