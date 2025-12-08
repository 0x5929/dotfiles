return {
	"lvimuser/lsp-inlayhints.nvim",
	lazy = true,
	ft = { "json", "jsonc", "typescript", "typescriptreact", "typescript.ts" },
	enabled = true,
	opts = {
		debug = true,
		only_current_line = true,
	},
	config = function(_, options)
		vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
		vim.api.nvim_create_autocmd("LspAttach", {
			group = "LspAttach_inlayhints",
			callback = function(args)
				if not (args.data and args.data.client_id) then
					return
				end

				local bufnr = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				require("lsp-inlayhints").on_attach(client, bufnr)
			end,
		})
		require("lsp-inlayhints").setup(options)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>hh",
			"<cmd>lua require('lsp-inlayhints').toggle()<CR>",
			{ noremap = true, silent = true }
		)
	end,
}
