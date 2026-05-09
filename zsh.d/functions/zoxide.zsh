# ~/.dot.d/zsh.d/functions/zoxide.zsh

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi
