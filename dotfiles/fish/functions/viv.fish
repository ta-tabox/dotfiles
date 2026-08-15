# ~/.config/fish/functions/viv.fish
function viv --description 'vivarium の運用スクリプト入口'
    command bash $HOME/vivarium/fermentary/tools/viv $argv
end
