return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    provider = "openai_fim_compatible",
    -- 候補ごとに別リクエストが走るので、単一 GPU の Ollama では 1 に固定する。
    n_completions = 1,
    -- 単位は文字数。窓の先頭が動くとプロンプトのキャッシュが外れて前処理が全量走るので、最悪値を絞る。
    context_window = 800,
    -- 7b が 30b のロードで退避されると再ロードに約 8 秒かかるので、既定の 3 秒では初回が必ず失敗する。
    request_timeout = 10,
    debounce = 200,
    throttle = 500,
    provider_options = {
      openai_fim_compatible = {
        -- Ollama は認証しないが、キーの環境変数名を空にできないので、常に存在する TERM を指す。
        api_key = "TERM",
        name = "Ollama",
        end_point = "http://localhost:11434/v1/completions",
        model = "qwen2.5-coder:1.5b",
        optional = {
          max_tokens = 24,
          top_p = 0.9,
          -- 中間を返した後も生成が続く挙動を、空行で打ち切る。
          stop = { "\n\n" },
        },
      },
    },
    virtualtext = {
      auto_trigger_ft = {
        "lua",
        "python",
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
        "vue",
        "prisma",
      },
      -- macOS のターミナルは、Option を Meta として扱う設定でないと <A-*> が届かない。
      -- 候補は 1 つに固定しているので、切り替えのキー（next・prev）は割り当てない。
      keymap = {
        accept = "<A-y>",
        accept_line = "<A-l>",
        dismiss = "<A-e>",
      },
    },
  },
}
