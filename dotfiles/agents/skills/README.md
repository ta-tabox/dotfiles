# Shared Skills

このディレクトリは AI エージェント向けの共通 SKILL Markdown を格納する場所である。
`claude` / `codex` / `cursor` から同じ内容を参照する。

```
dotfiles/agents/skills  →  ~/.claude/skills
                        →  ~/.cursor/skills
```

## 追跡方針

**共有するのは枠（このディレクトリと linklist のリンク定義）だけで、スキルの中身は git で追跡しない。**
`.gitignore` でこの README 以外を除外している。

理由:

- ここが解決するのは「1台のマシン上で複数のエージェントに同じスキルを見せる」ことであり、マシン間の同期ではない。リンク先が3つあることが本体の価値
- コーディング系のスキルはリポジトリ固有のことが多く、対象リポジトリの `.claude/skills/` に置いたほうが文脈が合う
- ユーザーレベルのスキルは環境に依存しがちで、マシンをまたぐと差分がノイズになる

ここに置いたスキルは**全セッションで description が読まれる**ため、使わないスキルを残すと毎回コンテキストを消費する。
不要になったら消すこと。

どうしても全マシンで共有したいスキルがあれば、明示的に追加する。

```sh
git add -f dotfiles/agents/skills/<skill-name>
```

## 中身の管理

このディレクトリの中身は、**ここにネストした独立の git リポジトリ**で管理する。
親リポジトリからは `.gitignore` で丸ごと除外されているため、両者は干渉しない。

submodule にはしない。
submodule は親側にコミットSHAを記録するため、環境ごとに違うはずのスキルが親の履歴に現れてしまう。

リモートを持たせる場合は、**環境ごとに別のprivateリポジトリ**を用意する。
同一リポジトリのブランチ分けは、mergeやpullの操作一つで両環境が混ざるため採らない。

新しいマシンで枠だけリンクされた状態から復元する手順は次の通り。

```sh
cd dotfiles/agents/skills
git init
echo README.md > .gitignore   # 親が追跡しているので二重管理を避ける
git remote add origin <この環境用のprivateリポジトリ>
git fetch origin && git checkout main
```

なお、上記の `git add -f` で親リポジトリに昇格させる方法と併用すると、同じファイルが二重に追跡される。
どちらか一方に寄せること。
