# dotfiles

## インストール

適宜 `linklist.txt`の中身を修正し
`script/`ディレクトリ内で実行

```bash
./link.sh

or

./unlink.sh
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

## Obsidian

iCloudにファイルがある場合は適宜手動でリンクを作成

```sh
ln -fsn ~/dotfiles/.obsidian.vimrc ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Brain/.obsidian.vimrc
```

```sh
unlink ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Brain/.obsidian.vimrc
```
