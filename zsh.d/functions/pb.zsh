function pb-kill-line() {
    zle kill-line
    print -rn -- $CUTBUFFER | pbcopy
}

function pb-yank() {
    CUTBUFFER=$(pbpaste)
    zle yank
}

zle -N pb-kill-line
zle -N pb-yank

bindkey "^y" pb-yank
bindkey "^k" pb-kill-line
