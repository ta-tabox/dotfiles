# fishを直接起動した時にhomebrewの環境変数を設定する
if test -x /opt/homebrew/bin/brew
   eval (/opt/homebrew/bin/brew shellenv fish)
end

