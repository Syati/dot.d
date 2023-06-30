
#================================#
# settings of each os            #
#================================#

case "${OSTYPE}" in
freebsd*|darwin*)
    export SHELL="/bin/zsh"
    export HOMEBREW="/opt/homebrew/bin"
    export DEFAULT_PATH="/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/bin:/sbin"
    export GNU_PATH="/opt/homebrew/opt/coreutils/libexec/gnubin"
    export JS_YARN_PATH="$HOME/.yarn/bin"
    export FLUTTER_PATH="$HOME/.flutter/bin"
    export POETRY_PATH="$HOME/.poetry/bin"
    export CUSTOM_PATH="$HOME/.bin:$HOME/.cargo/bin"
    export PATH="$GNU_PATH:$CUSTOM_PATH:$HOMEBREW:$JS_YARN_PATH:$POETRY_PATH:$FLUTTER_PATH:$DEFAULT_PATH"
    export PGDATA="/opt/homebrew/var/postgresql@14"
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

CWD=`dirname $(readlink -s -f ~/.zshrc)`


# fpath
fpath=(~/.zsh/completions $fpath)

#anyenv init
eval "$(anyenv init -)"
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

export GOOGLE_CLOUD_SDK="/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/"
source $GOOGLE_CLOUD_SDK/completion.zsh.inc
source $GOOGLE_CLOUD_SDK/path.zsh.inc

#direnv hook
eval "$(direnv hook zsh)"

#sheldon
export SHELDON_CONFIG_DIR="$CWD/sheldon"
export SHELDON_DATA_DIR="$CWD/sheldon/share"



#----------------------------#
# start up                   #
#----------------------------#

# auto tmux
if [ -z $OS ]; then
    if [ -z $EMACS ]; then
	    if which tmux 2>&1 >/dev/null; then
	        test -z $TMUX && (tmux attach || tmux new-session)
	    fi
    fi
fi


#----------------------------#
# export                     #
#----------------------------#
export LC_ALL=ja_JP.UTF-8
export TERM=xterm-256color

export EDITOR=emacsclient
export VISUAL=emacsclient

# docker
# export DOCKER_HOST=unix:///Users/mizuki-y/.lima/docker/sock/docker.sock

#for ls --color | less
export LESS='-R'


#================================#
# LOAD LIB                       #
#================================#
#keybind
bindkey -e  # emacs style


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
# seldon                     #
#----------------------------#
eval "$(sheldon source)"
base16_monokai
