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
