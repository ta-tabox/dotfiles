# dotfiles

AIエージェント向けの構成ガイド: [`AGENTS.md`](AGENTS.md)

## インストール

必要なツールは `dotfiles/Brewfile` から一括でインストールする。

```bash
brew bundle --file dotfiles/Brewfile

# 必要に応じて
./link.sh

or

./unlink.sh
```

`link.sh`/`unlink.sh` は `scripts/` ディレクトリ内で実行する。

### Brewfile運用ルール

- `brew bundle` は `dotfiles/Brewfile` に記載されたものを追加・更新するだけで、Brewfileにない既存パッケージは削除しない
- `brew bundle --cleanup` を使うと、Brewfileにないものは削除対象になる
- そのため、ベースはBrewfileで管理しつつ、個別インストールも併用できる

## Git

Add includes for `.gitconfig`

```gitconfig
[include]
    path = .gitconfig.d/user.gitconfig
    path = .gitconfig.d/alias.gitconfig
```

## Zsh

Add codes for `.zshrc`

```bash
ZSHHOME="${HOME}/.zsh.d"

if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi
```

## Obsidian

iCloudにファイルがある場合は適宜手動でリンクを作成

```sh
ln -fsn ~/dotfiles/dotfiles/.obsidian.vimrc ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Brain/.obsidian.vimrc
```

```sh
unlink ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Brain/.obsidian.vimrc
```

## NeoVim

### LazyVim

LazyVimを使用するにあたり以下のコマンドのインストールが必要

- ripgrep
- lazygit

上記は `dotfiles/Brewfile` に含まれるため `brew bundle` で導入される。

### lazygitの英語化

lazygitの設定ファイルに以下を追加する
`lazygit --print-config-dir`

`config.yml`

```config
gui:
  language: 'en'
```

## ツールのインストール

ターミナル上で使用するツールは `dotfiles/Brewfile` からまとめて導入する。

## Tmuxの設定

tmux設定は `dotfiles/tmux/` 配下で管理している。

- メイン設定: `dotfiles/tmux/tmux.conf`
- 補助スクリプト: `dotfiles/tmux/edit_scrollback.sh`

### [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)のインストール

- 新しい環境をセットアップする際は、`tpm` のインストールを忘れないこと。
- 具体的な手順は公式READMEを参照する: https://github.com/tmux-plugins/tpm

## Codex

`dotfiles/Brewfile` に cask として含まれているため `brew bundle` で導入される。

エージェント用の読み取り専用ラッパーはリポジトリ内の `dotfiles/bin/agent` で管理する。

- `agent-rg`: `rg --pre` を禁止した検索用ラッパー
- `agent-find`: `find -delete` / `-exec` 系を禁止した列挙用ラッパー

`scripts/link.sh` 実行後に `DOTFILES_ROOT` 環境変数を自動設定し、`~/.local/bin` と `$DOTFILES_ROOT/bin/agent` が PATH に入るよう zsh / fish を設定している。
`DOTFILES_ROOT` はリンクされたシェル設定ファイルの実体パスから自動で解決するため、リポジトリの配置場所に依存しない。

## claude code

claude codeはネイティブインストールを公式が推奨している

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

### 設定の2層構成

Claude 自身による設定の書き込み（`/config`、「常に許可」、`/auto-mode-setup`）は
**すべて `~/.claude/settings.json`（userSettings）に行く**。
ここを公開リポジトリへのシンボリックリンクにすると、環境固有の設定がそのまま
リポジトリへ流れ込むため、共有設定とマシンローカル設定を分離している。

| 層 | 実体 | 用途 |
| --- | --- | --- |
| 共有 | `dotfiles/claude/settings.shared.json`（リポジトリ管理） | 全マシン共通。`env` / `permissions` / `statusLine` / `theme` / `editorMode` など |
| ローカル | `~/.claude/settings.json`（実ファイル、リンクしない） | そのマシン限定。`autoMode` / `enabledPlugins` / `extraKnownMarketplaces` / 通知設定と Claude が書き込んだ設定 |

以下は環境・端末ごとに差が出るため共有しない。

- `enabledPlugins` / `extraKnownMarketplaces` — 導入プラグインはマシンごとに異なる
- `inputNeededNotifEnabled` / `agentPushNotifEnabled` — `/config` の Notifications
  （プッシュ通知）。アカウント・端末に紐づくうえ `/config` の書き込み先がローカル層なので、
  共有側に置くとトグルするたび食い違う

共有設定は `--settings` フラグ（flagSettings）で渡す。シェル関数がラッパーになっている。

- fish: `dotfiles/fish/functions/claude.fish`
- zsh: `dotfiles/zsh.d/05_claude.zsh`

どちらも `$DOTFILES_ROOT/claude/settings.shared.json` を絶対パスで渡す
（`--settings` はチルダ展開しないため）。Claude Code の Bash ツールは
zsh のスナップショットを経由するので、zsh 関数はツール内の `claude` 呼び出しにも効く。

マージ挙動:

- `permissions.allow` / `deny` / `ask` は全層の**和集合**
- 判定は behavior 優先（`deny` > `ask` > `allow`）で、層の優先度は関与しない。
  つまり**共有側の `deny` はローカルの `allow` では外せない**（外れないガードレール）
- `autoMode` は userSettings / flagSettings / policySettings からのみ読まれる

### 初回セットアップ

```sh
# 1. ~/.claude/settings.json をリンクではなく実ファイルにする
unlink ~/.claude/settings.json 2>/dev/null
printf '{}\n' > ~/.claude/settings.json

# 2. 新しいシェルを開いてラッパーを読み込ませる

# 3. そのマシン固有の autoMode を生成する
#    Claude Code 内で /auto-mode-setup を実行
```

`/auto-mode-setup` で生成された内容に特定リポジトリ名が焼き込まれていないか目視で確認する。
dotfiles は全プロジェクト共通の設定であり、固定値の `autoMode.environment` は
デフォルトの自己適応型判定（public/private の判定など）を壊す。

**共有設定に `autoMode` を入れてはいけない。** 環境固有の内容が全マシンに伝播する。

### 注意

ラッパー（`claude.fish` / `05_claude.zsh`）を変更したら **Claude Code の再起動が必要**。
Bash ツールが参照するシェルスナップショットはセッション開始時に取得されるため、
起動中のセッションには反映されない。

## mise

`dotfiles/Brewfile` に含まれているため `brew bundle` で導入される。

pnpm global bin は `PNPM_HOME`、package store は `~/.config/pnpm/rc` の `store-dir=${HOME}/.local/share/pnpm/store` で管理する。

## Python仮想環境

`uv` で管理する。
