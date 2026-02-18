# AGENTS.md

このリポジトリは、複数環境で共有するための `dotfiles` 管理用です。
AIエージェントはこのファイルを最初に読み、以下の前提で作業してください。

## 応答ルール

- 回答は日本語で行う。
- 既存設定を尊重し、不要なリファクタや構成変更を避ける。
- 破壊的操作（設定削除・リンク一括解除・履歴改変）を提案/実行する前に意図を確認する。

## コミットメッセージ規約（AIエージェント向け）

- コミットメッセージは英語で書く。
- 先頭に対象を示すプレフィックスを付ける（例: `fish:`, `tmux:`, `ghost:`）。
- 対象が定まらないコミットは粒度不正とみなし、分割して作成する。
- コミットメッセージは50文字以内で簡潔に書く。

## リポジトリ構成（要点）

- `dotfiles/`: 実際にホーム配下へリンクする設定本体。
- `scripts/`: シンボリックリンク作成/解除スクリプト。
  - `scripts/link.sh`: `dotfiles/linklist.txt` に基づいてリンク作成。
  - `scripts/unlink.sh`: `dotfiles/linklist.txt` に基づいてリンク解除。
  - `scripts/common.sh`: `__ln` / `__unlink` / `__mkdir` ヘルパー。
- `README.md`: セットアップ手順と運用メモ。
- `CLI_TOOLS.md`: 導入候補CLIのメモ（Brewfile未反映候補）。

## セットアップとリンク運用

1. ツール導入
   - `brew bundle --file dotfiles/Brewfile`
2. リンク作成
   - `scripts/link.sh` を実行。
3. リンク解除
   - `scripts/unlink.sh` を実行。

補足:
- リンク対象は `dotfiles/linklist.txt` で一元管理。
- `linklist.txt` の形式は `dotfiles内相対パス` と `リンク先パス` のペア。
- `~` はスクリプト内で `$HOME` に展開される。

## 主要設定ファイル

- シェル
  - `dotfiles/zshrc_base` と `dotfiles/zsh.d/*.zsh`
  - `dotfiles/fish/config.fish` と `dotfiles/fish/conf.d/*`
- Git
  - `dotfiles/gitconfig.d/user.gitconfig`
  - `dotfiles/gitconfig.d/alias.gitconfig`
- エディタ
  - `dotfiles/lazyvim/`（`~/.config/nvim` にリンク）
  - `dotfiles/_nvim/`（予備/別系統のNeovim設定）
  - `dotfiles/vimrc`
- ターミナル/TUI
  - `dotfiles/tmux.conf`
  - `dotfiles/starship.toml`
  - `dotfiles/alacritty/`
  - `dotfiles/ghostty/`
  - `dotfiles/lazygit/`
  - `dotfiles/bat/`
- エージェント関連
  - `dotfiles/codex/config.toml`
  - `dotfiles/codex/AGENTS.md`
  - `dotfiles/codex/prompts/`
  - `dotfiles/claude/settings.json`
  - `dotfiles/claude/CLAUDE.md`

## Brewfile方針

- 基本ツールは `dotfiles/Brewfile` で管理。
- `brew bundle` は追記・更新中心で、未記載パッケージを即削除しない。
- 不要パッケージ整理は必要時に `brew bundle --cleanup` を使う。

## 変更時のガイド（AIエージェント向け）

- まず `dotfiles/linklist.txt` を確認し、実ファイルとリンク先の対応を把握する。
- 既存の分割方針を維持する。
  - zsh は `zsh.d` 分割
  - fish は `config.fish` + `conf.d` + `functions`
  - Neovim は `lazyvim` 側を現行主系として扱う
- 新規ツール追加時は以下を同時に確認する。
  - 設定実体を `dotfiles/` に置く
  - `dotfiles/linklist.txt` へ追記
  - 必要なら `dotfiles/Brewfile` へ追記
  - 必要なら `README.md` へ導入手順追記
- iCloud配下など自動リンクしにくい箇所（Obsidian）はREADMEの手動手順を優先。

## 補足

- このファイルは「このリポジトリを初見で扱うAIエージェント向けの索引」です。
- 詳細な値やキーバインドは各設定ファイルを直接参照すること。
