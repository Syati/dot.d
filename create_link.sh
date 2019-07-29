#!/bin/sh

CWD=`dirname $(readlink -f $0)`

ln -s ${CWD}/zsh.d/.zshrc ~/.zshrc
ln -s ${CWD}/zsh.d/theme/dircolors.ansi-light ~/.dir_colors
ln -s ${CWD}/tmux.d/.tmux.conf ~/.tmux.conf
ln -s ${CWD}/emacs.d ~/.emacs.d
