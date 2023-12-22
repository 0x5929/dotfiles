return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				sass = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				-- install other formatters:
				-- 1. install formatter on local machine
				--    (NOT THE ONE INSIDE DOCKER, that one is inside docker and will not affect YOUR dev env)
				--    use your language package manager to install formatter globally
				-- 2. uncomment the following
				-- php = { "php_cs_fixer", "pint" },
				-- 3. remember to install via Mason after; go to its formatter tab:
				--    (i) to install and (X) to uninstall
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 10000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>ff", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 10000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
