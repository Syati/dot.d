#================================#
# settings of each os            #
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
    alias emacs='XMODIFIERS=@im=none emacs -nw'
    ;;
linux*)
	export PATH="$PATH":~/node_modules/.bin:~/android-sdks/tools:~/android-sdks/platform-tools:~/.framework/play-2.1.2:~/localenv/bin
    alias emacs='XMODIFIERS=@im=none emacs -nw'
    alias pbcopy='xclip -selection clipboard -i'
    alias pbpaste='xclip -selection clipboard -o'
    ;;
esac

#================================#
# common setting                 #
#================================#

# fpath
fpath=(~/.zsh/completions $fpath)
fpath=(~/.docker/completions $fpath)
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

#direnv hook
eval "$(direnv hook zsh)"

#sheldon
export SHELDON_CONFIG_DIR=~/.sheldon
export SHELDON_DATA_DIR=~/.sheldon/share


#ruby
export RUBY_CONFIGURE_OPTS="--enable-yjit"


#----------------------------#
# start up                   #
#----------------------------#

# auto tmux (avoid in IntelliJ)
# if [ -z "$OS" ] && [ -z "$EMACS" ] \
#       && [ "$TERM_PROGRAM" != "vscode" ] \
#       && [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]; then
#    if command -v tmux >/dev/null 2>&1; then
#        [ -z "$TMUX" ] && (tmux attach || tmux new-session)
#    fi
# fi


#----------------------------#
# export                     #
#----------------------------#
export LC_ALL=ja_JP.UTF-8
# RubyMineなどの特殊な環境（dumb）でない場合のみ 256color を設定
if [[ "$TERM" != "dumb" ]]; then
    export TERM=xterm-256color
fi


export EDITOR="code --reuse-window --wait"
export VISUAL="code --reuse-window --wait"

# docker
# export DOCKER_HOST=unix:///Users/mizuki-y/.lima/docker/sock/docker.sock

#for ls --color | less
export LESS='-R'

# psql 用
alias psql="PAGER='ov -m psql' psql"
alias mysql="PAGER='ov -m mysql' mysql"



#================================#
# LOAD LIB                       #
#================================#

# source a file only if it exists (keeps this rc portable across machines)
safe_source() {
  [[ -r "$1" ]] && source "$1"
}

#keybind
bindkey -e  # emacs style
bindkey -r '\ex' # M-x disable

#LANG
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac

# history configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=100000
HISTORY_IGNORE="(cd|pwd|l[sal]|mv|rm|mkdir)"

# #----------------------------#
# # option                     #
# #----------------------------#

setopt auto_menu        # toggle auto menu
setopt auto_cd           # auto change directory

setopt auto_pushd        # auto directory pushd that you can get dirs list by cd -[tab]
setopt complete_aliases  # aliased ls needs if file/dir completions work
setopt correct           # command correct edition before each completion attempt
setopt extended_history  # save hisotorical time
setopt hist_ignore_dups  # ignore duplication command history list
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt share_history     # share command history data
setopt list_packed       # compacked complete list display
setopt no_beep           # mute beep sound
setopt noautoremoveslash # no remove postfix slash of command line
setopt nolistbeep        # mute beep sound

#----------------------------#
# alias                      #
#----------------------------#

#alias docker-compose="docker compose"
alias df="df -h"
alias du="du -h"
alias gitlog='git log --pretty=oneline | cat'
alias gitloggraph='git log --decorate --graph --name-status --oneline'
alias l='ls --color'
alias la='ls -lhA --color'
alias ll='ls -lh -all --color'
alias ls='ls --color'
alias sed='gsed'
alias preview='open -a Preview'
alias chrome='open /Applications/Google\ Chrome.app/'
alias where="command -v"


#----------------------------#
# zstyle                     #
#----------------------------#

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=2
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _prefix _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' verbose true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s



#----------------------------#
# sheldon                     #
#----------------------------#
eval "$(sheldon source)"

#----------------------------#
# rust                       #
#----------------------------#
safe_source "$HOME/.cargo/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/mizuki-y/.lmstudio/bin"
# End of LM Studio CLI section

#----------------------------#
# entire
#----------------------------#
command -v entire >/dev/null 2>&1 && source <(entire completion zsh)

#----------------------------#
# 1password plugin           #
#----------------------------#
safe_source "$HOME/.config/op/plugins.sh"

# 1password ssh-agent (起動していれば切り替え)
_op_ssh_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
[[ -S "$_op_ssh_sock" ]] && export SSH_AUTH_SOCK="$_op_ssh_sock"
unset _op_ssh_sock

#----------------------------#
# git wt                     #
#----------------------------#
if command -v git >/dev/null 2>&1; then
  _git_wt_init="$(git wt --init zsh 2>/dev/null)"
  [[ -n "$_git_wt_init" ]] && eval "$_git_wt_init"
  unset _git_wt_init
fi

#----------------------------#
# gcloud sdk                 #
#----------------------------#
_gcloud_sdk_dir="/opt/homebrew/share/google-cloud-sdk"
safe_source "$_gcloud_sdk_dir/path.zsh.inc"
safe_source "$_gcloud_sdk_dir/completion.zsh.inc"
unset _gcloud_sdk_dir

# >>> otty shell integration >>>
# Added by Otty — toggle in Settings > Shell > Shell Integration.
# Inert unless launched by Otty (it sets $OTTY_SHELL_INTEGRATION).
if [[ -n "$OTTY_SHELL_INTEGRATION" ]]; then
  safe_source "$OTTY_SHELL_INTEGRATION/otty-integration.zsh"
fi
# <<< otty shell integration <<<
