CWD=`dirname $(readlink -f $0)`

source $CWD/antigen.zsh

antigen use oh-my-zsh

#antigen bundle git
antigen bundle z
antigen bundle virtualenvwrapper
antigen bundle docker
antigen bundle git

antigen bundle zsh-users/zsh-completions
antigen bundle $CWD/customs --no-local-clone
antigen bundle $CWD/fzf --no-local-clone


# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting


antigen theme robbyrussell

antigen apply
