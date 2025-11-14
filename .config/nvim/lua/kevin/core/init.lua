require("kevin.core.keymaps")
require("kevin.core.options")

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
	callback = function()
		vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
		vim.cmd("hi NormalNC ctermbg=NONE guibg=NONE")
	end,
})
