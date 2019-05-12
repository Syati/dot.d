export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

fzf_select_directory_history() {
    cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf +s --tac)"
    zle reset-prompt
}

fzf_select_command_history() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
    zle reset-prompt
}

zle -N fzf_select_directory_history
zle -N fzf_select_command_history

bindkey "^x^r" fzf_select_directory_history
bindkey "^r" fzf_select_command_history
