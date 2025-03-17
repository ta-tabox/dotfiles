function proot --description 'gitのプロジェクトルートに戻る'
  cd $(git rev-parse --show-toplevel)
end
