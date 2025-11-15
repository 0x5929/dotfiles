local M = {}

function M.setup()
	-- Visual-mode search & replace with:
	--  - "Find:" prompt
	--  - highlight all matches in the buffer
	--  - "Replace with:" prompt
	--  - "Flags [g]:" prompt (empty -> g)
	vim.keymap.set("x", "<leader>r", function()
		-- Ask what to find
		local find = vim.fn.input("Find: ")
		if find == nil or find == "" then
			print("Cancelled")
			return
		end

		-- Escape for search (avoid breaking / command)
		local search_pat = vim.fn.escape(find, [[\/]])

		-- Actually run a search to trigger highlight
		-- This sets @/ and, with hlsearch on, highlights all matches
		vim.cmd("silent! normal! /" .. search_pat .. "\\<CR>")
		vim.o.hlsearch = true

		-- Ask for replacement
		local replace = vim.fn.input("Replace with: ")

		-- Flags: default to "g" (global) if empty
		local flags = vim.fn.input("Flags [g]: ")
		if flags == nil or flags == "" then
			flags = "g"
		end

		-- Escape again for substitution (/, \)
		local escaped_find = vim.fn.escape(find, [[\/]])
		local escaped_replace = vim.fn.escape(replace, [[\/]])

		-- Run the substitute over the visual selection ('<,'>)
		local cmd = string.format("'<,'>s/%s/%s/%s", escaped_find, escaped_replace, flags)
		vim.cmd(cmd)
	end, { desc = "Search & replace in selection (prompted, highlighted)" })
end

return M
