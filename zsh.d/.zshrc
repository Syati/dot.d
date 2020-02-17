#================================#
# settings of each os            #
#================================#

case "${OSTYPE}" in
freebsd*|darwin*)
    export SHELL="/usr/local/bin/zsh"
	export DEFAULT_PATH="/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/bin:/sbin"
    export GNU_PATH="/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin"
    export JS_YARN_PATH="$HOME/.yarn/bin"
    export POETRY_PATH="$HOME/.poetry/bin"
    export CUSTOM_PATH="$HOME/.bin"
    export PATH="$CUSTOM_PATH:$GNU_PATH:$JS_YARN_PATH:$POETRY_PATH:$DEFAULT_PATH"

	alias emacs='XMODIFIERS=@im=none emacs -nw'
    ;;
linux*)
	export PATH="$PATH":~/node_modules/.bin:~/android-sdks/tools:~/android-sdks/platform-tools:~/.framework/play-2.1.2:~/localenv/bin
    alias emacs='XMODIFIERS=@im=none emacs -nw'
    alias pbcopy='xclip -selection clipboard -i'
    alias pbpaste='xclip -selection clipboard -o'
    ;;
esac

#anyenv init
eval "$(anyenv init -)"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

export GOOGLE_CLOUD_SDK="/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/"
source $GOOGLE_CLOUD_SDK/completion.zsh.inc
source $GOOGLE_CLOUD_SDK/path.zsh.inc


#================================#
# common setting                 #
#================================#

CWD=`dirname $(readlink -s -f ~/.zshrc)`
eval `dircolors ~/.dir_colors`

#----------------------------#
# start up                   #
#----------------------------#

# auto tmux
if [ -z $OS ]; then
    if [ -z $EMACS ]; then
	    if which tmux 2>&1 >/dev/null; then
	        test -z "$TMUX" && (tmux attach || tmux new-session)
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

#virtual env
#export WORKON_HOME=$HOME/.virtualenvs
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python

#for ls --color | less
export LESS='-R'

#================================#
# LOAD LIB                       #
#================================#

source $CWD/zsh_antigen.zsh

#keybind
bindkey -e  # emacs style

#LANG
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac

# prompt
PROMPT="%n%% "
RPROMPT="[%~]"
SPROMPT="%r is correct? [n,y,a,e]: "


# Use modern completion system
# autoload -Uz compinit
# compinit

# history configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

#----------------------------#
# option                     #
#----------------------------#

#setopt auto_menu        # toggle auto menu
#setopt auto_cd           # auto change directory
setopt auto_pushd        # auto directory pushd that you can get dirs list by cd -[tab]
setopt complete_aliases  # aliased ls needs if file/dir completions work
setopt correct           # command correct edition before each completion attempt
setopt extended_history  # save hisotorical time
setopt hist_ignore_dups  # ignore duplication command history list
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt list_packed       # compacked complete list display
setopt no_beep           # mute beep sound
setopt noautoremoveslash # no remove postfix slash of command line
setopt nolistbeep        # mute beep sound
setopt share_history     # share command history data


#----------------------------#
# alias                      #
#----------------------------#

#alias composer="php -d memory_limit=-1 -n /usr/local/Cellar/composer/1.5.2/libexec/composer.phar"
alias df="df -h"
alias du="du -h"
alias gitlog='git log --pretty=oneline | cat'
alias gitloggraph='git log --decorate --graph --name-status --oneline'
alias l='ls --color'
alias la='ls -lhA --color'
alias ll='ls -lh -all --color'
alias ls='ls --color'
alias where="command -v"
alias -s bmp=eog
alias -s gif=eog
alias -s html=firefox
alias -s jpeg=eog
alias -s jpg=eog
alias -s png=eog
alias -s txt=cat
alias -s xhtml=firefox

#----------------------------#
# zstyle                     #
#----------------------------#

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval $(dircolors -b ~/.dir_colors)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'



#----------------------------#
# dir                        #
#----------------------------#
typeset -ga chpwd_functions

autoload -U chpwd_recent_dirs cdr
chpwd_functions+=chpwd_recent_dirs
zstyle ":chpwd:*" recent-dirs-max 500
zstyle ":chpwd:*" recent-dirs-default true
zstyle ":completion:*" recent-dirs-insert always



export PATH="${GOPATH}/bin:/Users/mizuki-y/.anyenv/envs/goenv/shims:${PATH}"
export GOENV_SHELL=zsh
source '/Users/mizuki-y/.anyenv/envs/goenv/libexec/../completions/goenv.zsh'

eval "$(goenv init -)"

eval "$(direnv hook zsh)"
