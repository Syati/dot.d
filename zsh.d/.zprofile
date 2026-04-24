# ~/.zprofile
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# Added by Toolbox App
export PATH="$PATH:/Users/mizuki-y/Library/Application Support/JetBrains/Toolbox/scripts"

