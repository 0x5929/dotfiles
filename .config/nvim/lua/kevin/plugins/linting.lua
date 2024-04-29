return {
	"mfussenegger/nvim-lint",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			vue = { "eslint_d" },
			svelte = { "eslint_d" },
			-- python = { "pylint" },
			-- install other linters:
			-- 1. install linters on local machine
			--    (NOT THE ONE INSIDE DOCKER, that one is inside docker and will not affect YOUR dev env)
			--    use your language package manager to install linters globally
			-- 2. uncomment the following
			-- php = { "phpcs", "phpstan" },
			-- 3. remember to install via Mason after; go to its linter tab:
			--    (i) to install and (X) to uninstall
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
