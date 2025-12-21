return {
  {
    "neovim/nvim-lspconfig",
    --- @class PluginLspOpts
    opts = {
      --- @type lspconfig.options
      servers = {
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifier = "non-relative",
                importModuleSpecifierEnding = "minimal",
                quotePreference = "double",
              },
            },
            javascript = {
              preferences = {
                importModuleSpecifier = "non-relative",
                importModuleSpecifierEnding = "minimal",
                quotePreference = "double",
              },
            },
          },
        },
      },
    },
  },
}
