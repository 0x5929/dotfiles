return {
	"f-person/git-blame.nvim",
  config = function()
    local blame = require('gitblame')
    blame.setup({})

    local keymap = vim.keymap -- for conciseness
    keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>")
  end,
}
