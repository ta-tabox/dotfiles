return {
  {
    "Mofiqul/dracula.nvim",
    opts = {
      -- 透明を有効化
      -- transparent_bg = true, -- default false
      overrides = {
        -- default #3b4048
        NonText = { fg = "#6d6860"}
      }
    }
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
