function powerline_precmd() {
    eval "$(powerline-go -eval -error $? -cwd-max-depth 3 -hostname-only-if-ssh -modules host,ssh,cwd,perms,jobs -modules-right git)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}


if type powerline-go > /dev/null 2>&1; then
    install_powerline_precmd
fi
