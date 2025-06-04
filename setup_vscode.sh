#!/bin/sh

CWD=$(cd $(dirname $0) && pwd)
VSCODE_DIR=${CWD}/vscode
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User

if !(type code > /dev/null 2>&1); then
    brew install visual-studio-code --cask
fi

ln -v -s -f ${VSCODE_DIR}/settings.json "${VSCODE_SETTING_DIR}/settings.json"
ln -v -s -f ${VSCODE_DIR}/keybindings.json "${VSCODE_SETTING_DIR}/keybindings.json"

cat ${VSCODE_DIR}/extensions | while read line
do
 code --install-extension $line
done

code --list-extensions > ${VSCODE_DIR}/extensions

echo "DONE"
