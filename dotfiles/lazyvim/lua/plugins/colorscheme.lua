return {
  {
    "Mofiqul/dracula.nvim",
    opts = {
      -- 透明を有効化
      transparent_bg = true, -- default false
      overrides = {
        -- default #3b4048
        NonText = { fg = "#6d6860" },

        -- vidual mode slection
        Visual = { bg = "#525970", fg = "NONE"},
        VisualNOS = { bg = "#525970", fg = "NONE"},

        -- mini.diff overlay: delta / Claude Code 風の控えめな背景色
        MiniDiffOverAdd = { bg = "#1e3a2b", fg = "NONE" },
        MiniDiffOverChangeBuf = { bg = "#2f6a45", fg = "NONE" },
        MiniDiffOverChange = { bg = "#4a2634", fg = "NONE" },
        MiniDiffOverDelete = { bg = "#4a2634", fg = "NONE" },
        MiniDiffOverContext = { bg = "#33262f", fg = "NONE" },
        MiniDiffOverContextBuf = { bg = "#24332d", fg = "NONE" },

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
