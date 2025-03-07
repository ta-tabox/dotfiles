alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# vim -> nvim
alias vi='vim'
alias vim='nvim'
alias view='nvim -R'

# python
alias python="python3"
alias pip="pip3"

# locateデータベース更新
alias updatedb='sudo /usr/libexec/locate.updatedb'

# ezaの設定
if type eza >/dev/null 2>&1
  alias e 'eza --icons --git'
  alias ea 'eza -a --icons --git'
  alias ee 'eza -aahl --icons --git'
  alias et 'eza -T -L 3 -a -I "node_modules|.git|.cache" --color=always --icons'
  alias eta 'eza -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'

  function l
    clear
    eza --icons --git $argv
  end

  function la
    clear
    eza -a --icons --git $argv
  end

  function ll
    clear
    eza -aahl --icons --git $argv
  end

  function lt
    clear
    eza -T -L 3 -a -I "node_modules|.git|.cache" --color=always --icons $argv
  end

  function lta
    clear
    eza -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r $argv
  end
end
