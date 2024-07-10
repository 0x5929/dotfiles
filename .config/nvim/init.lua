if vim.g.vscode then
	-- VSCode extension
	local keymap = vim.keymap -- for conciseness
	keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
else
	-- ordinary Neovim
	require("kevin.core")
	require("kevin.lazy")
end
