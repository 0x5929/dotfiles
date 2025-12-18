return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- If enabled somewhere, this preset forces search to the bottom.
      opts.presets = opts.presets or {}
      opts.presets.bottom_search = false -- :contentReference[oaicite:2]{index=2}

      -- Force / and ? to use the popup view (same idea as the ":" popup)
      opts.cmdline = opts.cmdline or {}
      opts.cmdline.format = opts.cmdline.format or {}
      opts.cmdline.format.search_down =
        vim.tbl_deep_extend("force", opts.cmdline.format.search_down or {}, { view = "cmdline_popup" })
      opts.cmdline.format.search_up =
        vim.tbl_deep_extend("force", opts.cmdline.format.search_up or {}, { view = "cmdline_popup" })

      -- Optional: move the popup closer to the center (tune to taste)
      -- opts.views = opts.views or {}
      -- opts.views.cmdline_popup = vim.tbl_deep_extend("force", opts.views.cmdline_popup or {}, {
      --   position = { row = "40%", col = "50%" },
      -- })
    end,
  },
}
