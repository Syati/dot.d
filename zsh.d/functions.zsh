#----------------------------#
# funcs                      #
#----------------------------#
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='
  --height 40% --reverse --border
  --bind ctrl-k:kill-line
  --bind ctrl-v:page-down
  --bind alt-v:page-up
'

function fzf_select_directory_history() {
    select_path=$(z -l 2>&1 | sed -r 's/\s*[0-9]*\s*//' | fzf +s --tac)
    if [ ! -z $select_path ]; then
        BUFFER="cd ${select_path}"
        zle accept-line
    fi
    zle reset-prompt
}

function fzf_select_command_history() {
    BUFFER=$( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | sed -r 's/\s*[0-9]*\s*//' | fzf +s --tac)
    CURSOR=$#BUFFER
    zle reset-prompt
}

function pb-kill-line() {
    zle kill-line
    print -rn -- $CUTBUFFER | pbcopy
}

function pb-yank() {
    CUTBUFFER=$(pbpaste)
    zle yank
}

zle -N fzf_select_directory_history
zle -N fzf_select_command_history
zle -N pb-kill-line
zle -N pb-yank

bindkey "^x^r" fzf_select_directory_history
bindkey "^r" fzf_select_command_history
bindkey "^y" pb-yank
bindkey "^k" pb-kill-line
