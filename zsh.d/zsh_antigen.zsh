CWD=`dirname $(readlink -f $0)`

source $CWD/antigen.zsh

antigen use oh-my-zsh

#antigen bundle git
antigen bundle z
antigen bundle virtualenvwrapper

antigen bundle mooz/percol
antigen bundle zsh-users/zsh-completions
antigen bundle $CWD/customs --no-local-clone

antigen apply
