# CLIツール候補（Webアプリ開発 / ターミナル中心）

目的: 開発効率を上げるための候補一覧。Brewfileには追加しないドキュメント用メモ。

## 候補

- `jq`  
  JSON加工の定番。APIレスポンスやログの整形に強い。
- `yq`  
  YAML/JSON/INI/XML対応。CI設定やK8sマニフェスト編集に便利。
- `watchexec`  
  ファイル変更でコマンドを自動再実行。
- `hyperfine`  
  コマンドの実行時間を統計的に比較できる。
- `xh`  
  HTTPクライアント。`httpie` と用途が被るため置き換え用途向け。

## Brewで入れる場合

```bash
brew install jq yq watchexec hyperfine xh
```

## gh拡張（Brewfile管理外）

`gh extension` は dotfiles で管理していないため、新しい環境では手で入れる。

- `github/gh-stack`  
  スタック型PR（PRを積み重ねる）を扱う。`gh stack init` / `add` / `submit` / `sync` / `view`。

```bash
gh extension install github/gh-stack
```
