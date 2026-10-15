return {
  {
    "coder/claudecode.nvim",
    -- 既定ではキー入力まで読み込まれず、IDE 接続用のサーバーと lock ファイルが作られない
    -- cmux の右ペインの claude --ide から接続するため、起動時に読み込む
    lazy = false,
    opts = {
      auto_start = true,
      -- ターミナルは cmux のペインを使うので nvim 内では開かない
      terminal = { provider = "none" },
    },
    init = function()
      -- 送信後、vimc が作った cmux の右ペイン（Claude）へフォーカスを移す
      vim.api.nvim_create_autocmd("User", {
        pattern = "ClaudeCodeSendComplete",
        callback = function()
          local surface = vim.env.VIMC_CLAUDE_SURFACE
          if surface and surface ~= "" then
            vim.system({ "cmux", "focus-panel", "--panel", surface })
          end
        end,
      })
    end,
    keys = {
      -- nvim 内で Claude のターミナルを開くキーを無効化する
      { "<leader>ac", false },
      { "<leader>af", false },
      { "<leader>ar", false },
      { "<leader>aC", false },
    },
  },
}
