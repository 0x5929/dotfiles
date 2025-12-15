return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before everything else
    opts = {
      flavour = "mocha",
      transparent_background = true,

      integrations = {
        neotree = {
          transparent = true,
        },
        native_lsp = {
          enabled = true,
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
