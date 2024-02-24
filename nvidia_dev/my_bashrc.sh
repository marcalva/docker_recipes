. "$HOME/.cargo/env"
export BAT_PAGER="less -RF"
export LD_LIBRARY_PATH="/usr/local/lib/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="fd --type f --strip-cwd-prefix"
export FZF_DEFAULT_OPTS="--no-mouse --height=50% --layout=reverse \
--border --info=inline --margin=1 --padding=1 \
--bind ctrl-l:toggle-preview,ctrl-y:preview-up,ctrl-e:preview-down,\
ctrl-b:preview-page-up,ctrl-f:preview-page-down,\
ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,\
shift-up:preview-top,shift-down:preview-bottom"
alias vim=nvim
