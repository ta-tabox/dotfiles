# zshのalias
alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# 設定ファイル
alias zshconfig='vim ~/.zshrc'

# vim -> nvim
alias vim='nvim'
alias vi='nvim'
alias view='nvim -R'

# git
alias lg='lazygit'
# プロジェクトルートに戻る
alias proot='cd $(git rev-parse --show-toplevel)'

# python
alias python="python3"
alias pip="pip3"

# locateデータベース更新
alias updatedb='sudo /usr/libexec/locate.updatedb'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# ezaの設定
if [[ $(command -v eza) ]]; then
  alias e='eza --icons --git'
  alias ea='eza -a --icons --git'
  alias la=ea
  alias ee='eza -aahl --icons --git'
  alias ll=ee
  alias et='eza -T -L 3 -a -I "node_modules|.git|.cache" --icons'
  alias lt=et
  alias eta='eza -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
  alias lta=eta
  alias l='clear && e'
fi

########################################
# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi
