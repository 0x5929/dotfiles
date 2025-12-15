return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false, -- important: load at startup so highlights are cleared immediately
    priority = 1000, -- load early
    config = function()
      require("transparent").setup({
        -- Make these UI areas transparent too (optional but common)
        extra_groups = {
          "NormalFloat", -- Lazy, Mason, LspInfo, etc.
          "FloatBorder",
          "NeoTreeNormal", -- Neo-tree main panel
          "NeoTreeNormalNC", -- Neo-tree when not focused
          "NeoTreeEndOfBuffer",
          "NeoTreeWinSeparator",
        },
        exclude_groups = {},
      })

      -- Enable transparency automatically on launch
      vim.cmd("TransparentEnable")

      -- If Neo-tree (or other plugins) define highlights later, clear by prefix as well
      -- This is safe to call; it just clears groups that exist.
      require("transparent").clear_prefix("NeoTree")
    end,
  },
}
