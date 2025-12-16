return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configuration to disable the original ruff_lsp server
        ruff_lsp = {
          mason = false, -- Prevents Mason from managing/installing the server executable
          enabled = false, -- Explicitly disable the server from starting
          -- The following options are sometimes used by older configs, good to cover them
          on_attach = function() end,
          capabilities = {},
        },
        -- Configuration to disable the newer 'ruff' native server (more common now)
        ruff = {
          mason = false, -- Prevents Mason from managing/installing the server executable
          enabled = false, -- Explicitly disable the server from starting
          -- The following options are sometimes used by older configs, good to cover them
          on_attach = function() end,
          capabilities = {},
        },
      },
      -- Ensure overall LSP capabilities or setup functions don't re-enable it unexpectedly
      setup = {
        ruff_lsp = nil,
        ruff = nil,
      },
    },
  },
}
