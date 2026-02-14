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

### [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)のインストール

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

プラグインのインストール `Ctrl + g -> I`

## Codex

`dotfiles/Brewfile` に cask として含まれているため `brew bundle` で導入される。

## claude code

claude codeはネイティブインストールを公式が推奨している

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

## mise

`dotfiles/Brewfile` に含まれているため `brew bundle` で導入される。

## Python仮想環境

`uv` で管理する。
