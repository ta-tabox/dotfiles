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
