# 1. 履歴や fzf から除外したいコマンドリスト
local -a my_ignore_commands
my_ignore_commands=(
    cd pwd ls la ll history mv
    "rm|mkdir"      # 履歴から再実行すると危ないもの（お好みで）
)
local ignore_pattern="^(\*|${(j:|:)my_ignore_commands})($|[[:space:]])"

#----------------------------#
# funcs                      #
#----------------------------#
local -a fzf_exclude_dirs=(
    .git .local .cache .gem .zsh_sessions .lmstudio
    node_modules dist tmp 
)
local exclude_opts="${(@)fzf_exclude_dirs/#/--exclude }"
export FZF_DEFAULT_COMMAND="fd --type f --hidden ${exclude_opts}"
export FZF_CTRL_T_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}"'
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --bind ctrl-k:kill-line
  --bind ctrl-v:page-down
  --bind alt-v:page-up
'

function fzf_select_directory_history() {
    select_path=$(zoxide query -i)
    if [ ! -z $select_path ]; then
        BUFFER="cd ${select_path}"
        zle accept-line
    fi
    zle reset-prompt
}

# 3. fzf 連携関数
function fzf_select_command_history() {
    # 履歴取得時に最初から grep でフィルタリング
    BUFFER=$(fc -rl 1 | \
        sed -E 's/^\s*[0-9]+\*?\s*//' | \
        grep -Ev "$ignore_pattern" | \
        fzf --no-sort --reverse --query="$LBUFFER")

    CURSOR=$#BUFFER
    zle reset-prompt
}


function pb-kill-line() {
    zle kill-line
    print -rn -- $CUTBUFFER | pbcopy
}

function pb-yank() {
    CUTBUFFER=$(pbpaste)
    zle yank
}

function ghq-fzf() {
  local src=$(ghq list | fzf --preview "cat $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf_select_directory_history
zle -N fzf_select_command_history
zle -N pb-kill-line
zle -N pb-yank
zle -N ghq-fzf

bindkey "^y" pb-yank
bindkey "^k" pb-kill-line

# JetBrainsのターミナル以外でbindkeyを設定
if [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
  bindkey "^x^r" fzf_select_directory_history
  bindkey "^r" fzf_select_command_history
  bindkey "^t" ghq-fzf
fi
