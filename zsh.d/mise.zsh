if [ -x "$HOME/.local/bin/mise" ] && ! (( $+functions[_mise_hook] )); then
  eval "$($HOME/.local/bin/mise activate zsh)"
fi
