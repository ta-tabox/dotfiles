set -x FZF_DEFAULT_COMMAND 'fd --type f'

set -x FZF_DEFAULT_OPTS "--style full"

# Preview file content using bat (https://github.com/sharkdp/bat)
set -x FZF_CTRL_T_OPTS "
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-Y to copy the command into clipboard using pbcopy
set -x FZF_CTRL_R_OPTS "
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
set -x FZF_ALT_C_OPTS "
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# fishではcompletionに ** が使用できない
# see https://github.com/junegunn/fzf/issues/484
#
# Use ~~ as the trigger sequence instead of the default **
# set -x FZF_COMPLETION_TRIGGER '~~'

# Options to fzf command
# set -x FZF_COMPLETION_OPTS "--border --info=inline"

# Options for path completion (e.g. vim **<TAB>)
# set -x FZF_COMPLETION_PATH_OPTS '--walker file,dir,follow,hidden'

# Options for directory completion (e.g. cd **<TAB>)
# set -x FZF_COMPLETION_DIR_OPTS '--walker dir,follow'
