#!/bin/sh

CWD=`dirname $(readlink -f $0)`

ln -s ${CWD}/zsh.d/.zshrc ~/.zshrc
ln -s ${CWD}/tmux.d/.tmux.conf ~/.tmux.conf
ln -s ${CWD}/percol.d ~/.percol.d
ln -s ${CWD}/emacs.d ~/.emacs.d
ln -s ${CWD}/keysnail.d/.keysnail.js ~/.keysnail.js

