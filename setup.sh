#!/bin/sh

CWD=$(cd $(dirname $0) && pwd)

# install brew
if !(type brew > /dev/null 2>&1); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install sheldon for zsh pckage manager
if !(type sheldon > /dev/null 2>&1); then
    brew install sheldon
    mkdir -p ~/.sheldon/
fi


# install powerline-go
if !(type sheldon > /dev/null 2>&1); then
    brew install powerline-go
fi


ln -v -s -f ${CWD}/zsh.d/sheldon.plugins.toml ~/.sheldon/plugins.toml
ln -v -s -f ${CWD}/zsh.d/.zshrc ~/.zshrc
ln -v -s -f ${CWD}/zsh.d/theme/dircolors.ansi-light ~/.dir_colors
ln -v -s -f ${CWD}/tmux.d/.tmux.conf ~/.tmux.conf
ln -v -s -f ${CWD}/emacs.d ~/.emacs.d


echo 'DONE'


echo <<EOF "
Plz install powerline-fonts visiting below site

https://github.com/powerline/fonts

EOF
