-- return {
-- 	"akinsho/bufferline.nvim",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	version = "*",
-- 	opts = { -- required(bufferline).setup(opts)
-- 		options = {
-- 			mode = "tabs",
-- 			separator_style = "slant",
-- 		},
-- 	},
-- }
return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "slant",
		},
	},
	config = function(_, opts)
		-- normal bufferline setup
		require("bufferline").setup(opts)

		-- now *force* transparency on the actual highlight groups
		local transparent_groups = {
			"BufferLineFill",
			"BufferLineBackground",
			"BufferLineTab",
			"BufferLineTabSelected",
			"BufferLineTabClose",
			"BufferLineTabSeparator",
			"BufferLineTabSeparatorSelected",

			"BufferLineBufferVisible",
			"BufferLineBufferSelected",

			"BufferLineSeparator",
			"BufferLineSeparatorVisible",
			"BufferLineSeparatorSelected",

			"BufferLineCloseButton",
			"BufferLineCloseButtonVisible",
			"BufferLineCloseButtonSelected",
		}

		for _, group in ipairs(transparent_groups) do
			-- keep existing fg, just nuke bg
			local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
			if ok then
				hl.bg = nil
				hl.ctermbg = nil
				vim.api.nvim_set_hl(0, group, hl)
			else
				-- if group doesn't exist yet, just set a bare transparent one
				vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
			end
		end
	end,
}
