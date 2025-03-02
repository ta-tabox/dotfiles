########################################
# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
function C --description 'パイプでクリップボードにコピー'
  if type pbcopy >/dev/null 2>&1
      # Mac
      command pbcopy $argv
  else if type xsel >/dev/null 2>&1
      # Linux
      command xsel --input --clipboard $argv
  else if type putclip >/dev/null 2>&1
      # Cygwin
      command putclip $argv
  end
end
