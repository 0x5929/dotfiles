return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#0f1416',
				base01 = '#0f1416',
				base02 = '#8a9396',
				base03 = '#8a9396',
				base04 = '#e3eff2',
				base05 = '#f8fdff',
				base06 = '#f8fdff',
				base07 = '#f8fdff',
				base08 = '#ff9fbf',
				base09 = '#ff9fbf',
				base0A = '#a2eafe',
				base0B = '#a5ffae',
				base0C = '#cef4ff',
				base0D = '#a2eafe',
				base0E = '#b3eeff',
				base0F = '#b3eeff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#8a9396',
				fg = '#f8fdff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#a2eafe',
				fg = '#0f1416',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#8a9396' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cef4ff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#b3eeff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#a2eafe',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#a2eafe',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#cef4ff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffae',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#e3eff2' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#e3eff2' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#8a9396',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
