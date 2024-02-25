# dotfiles

## インストール

適宜 `linklist.txt`の中身を修正し
dotfilesディレクトリで実行

```bash
bash link.sh
```

## Git

Add includes for `.gitconfig`

```gitconfig
[include]
    path = .gitconfig.d/user.gitconfig
    path = .gitconfig.d/alias.gitconfig
```
