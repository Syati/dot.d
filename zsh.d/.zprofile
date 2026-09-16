# ~/.zprofile
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# Added by Toolbox App
export PATH="$PATH:/Users/mizuki-y/Library/Application Support/JetBrains/Toolbox/scripts"

# 1password ssh-agent (起動していれば切り替え)
# non-interactive shell でも SSH_AUTH_SOCK を効かせるため .zshrc ではなくここに置く
_op_ssh_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
[[ -S "$_op_ssh_sock" ]] && export SSH_AUTH_SOCK="$_op_ssh_sock"
unset _op_ssh_sock

#================================#
# PATH settings of each os       #
#================================#

case "${OSTYPE}" in
freebsd*|darwin*)
    export SHELL="/bin/zsh"
    export HOMEBREW="/opt/homebrew/bin:/opt/homebrew/sbin"
    export DEFAULT_PATH="/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/bin:/sbin"
    export GNU_PATH="/opt/homebrew/opt/coreutils/libexec/gnubin"
    export JS_YARN_PATH="$HOME/.yarn/bin"
    export FLUTTER_PATH="$HOME/.flutter/bin"
    export CUSTOM_PATH="$HOME/.bin:$HOME/.local/bin"
    export MYSQL_PATH="/opt/homebrew/opt/mysql@5.7/bin"
    export PSQL_PATH="/opt/homebrew/opt/libpq/bin"
    export PATH="$GNU_PATH:$CUSTOM_PATH:$HOMEBREW:$JS_YARN_PATH:$FLUTTER_PATH:$MYSQL_PATH:$PSQL_PATH:$DEFAULT_PATH"
    #export PGDATA="/opt/homebrew/var/postgresql@18"
    ;;
linux*)
    export PATH="$PATH":~/node_modules/.bin:~/android-sdks/tools:~/android-sdks/platform-tools:~/.framework/play-2.1.2:~/localenv/bin
    ;;
esac

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/mizuki-y/.lmstudio/bin"
# End of LM Studio CLI section

