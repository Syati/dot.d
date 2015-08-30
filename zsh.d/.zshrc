#================================#
# settings of each os            #
#================================#

case "${OSTYPE}" in
freebsd*|darwin*)
    export SHELL="/usr/local/bin/zsh"
	export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:~/Qt/5.3/clang_64/bin"
    export NODE_PATH="/usr/local/lib/node_modules"
	alias emacs='XMODIFIERS=@im=none emacs'
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

CWD=`dirname $(readlink -s ~/.zshrc)`

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
export TERM=xterm-256color
export CMAKE_PREFIX_PATH=~/Qt/5.3/clang_64

export EDITOR=emacsclient
export VISUAL=emacsclient

#virtual env
export WORKON_HOME=~/.virtualenvs

#rbenv
[ `whence rbenv` ] && eval "$(rbenv init -)"


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

## historical backward/forward search with linehead string binded to Alt+P/Alt+N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "ALT+P" history-beginning-search-backward-end
bindkey "ALT+N" history-beginning-search-forward-end 

#----------------------------#
# option                     #
#----------------------------#

#setopt auto_menu        # toggle auto menu
setopt auto_cd           # auto change directory
setopt auto_pushd        # auto directory pushd that you can get dirs list by cd -[tab]
setopt complete_aliases  # aliased ls needs if file/dir completions work
setopt correct           # command correct edition before each completion attempt
setopt extended_history  # save hisotorical time
setopt hist_ignore_dups  # ignore duplication command history list
setopt list_packed       # compacked complete list display
setopt no_beep           # mute beep sound
setopt noautoremoveslash # no remove postfix slash of command line
setopt nolistbeep        # mute beep sound
setopt share_history     # share command history data 

#----------------------------#
# alias                      #
#----------------------------#

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
