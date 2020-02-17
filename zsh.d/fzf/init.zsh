export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='
  --height 40% --reverse --border
  --bind ctrl-k:kill-line
  --bind ctrl-v:page-down
  --bind alt-v:page-up
'

fzf_select_directory_history() {
    select_path=$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf +s --tac)
    if [ ! -z $select_path ]; then
        BUFFER="cd ${select_path}"
        zle accept-line
    fi
    zle reset-prompt
}

fzf_select_command_history() {
    BUFFER=$( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N fzf_select_directory_history
zle -N fzf_select_command_history

bindkey "^x^r" fzf_select_directory_history
bindkey "^r" fzf_select_command_history
