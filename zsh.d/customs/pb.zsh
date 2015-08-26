#pbcopy and pbpaste
function pb-kill-line() {
    zle kill-line
    print -rn $CUTBUFFER | pbcopy
}

function pb-yank() {
    CUTBUFFER=$(pbpaste)
    zle yank
}

## yank and kill bind to Ctrl+y/Ctrl+k
zle -N pb-kill-line
zle -N pb-yank
bindkey "^y" pb-yank
bindkey "^k" pb-kill-line

