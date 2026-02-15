return {
  {
    "Mofiqul/dracula.nvim",
    opts = {
      -- 透明を有効化
      transparent_bg = true, -- default false
      overrides = {
        -- default #3b4048
        NonText = { fg = "#6d6860" },

        -- 透過設定を行う場合は以下のフロートの背景も調整する
        -- floating windows
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        -- telescope
        TelescopeNormal = { bg = "NONE" },
        TelescopeBorder = { bg = "NONE" },
        TelescopePromptNormal = { bg = "NONE" },
        TelescopePromptBorder = { bg = "NONE" },
        TelescopeResultsNormal = { bg = "NONE" },
        TelescopeResultsBorder = { bg = "NONE" },
        TelescopePreviewNormal = { bg = "NONE" },
        TelescopePreviewBorder = { bg = "NONE" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
