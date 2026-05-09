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


function ghq-fzf() {
  local src=$(ghq list | fzf --preview "cat $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle reset-prompt
}

function yazi-zle() {
  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi --cwd-file="$tmp"
  if [ -f "$tmp" ]; then
    local cwd
    cwd="$(cat "$tmp")"
    if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      BUFFER="cd ${(q)cwd}"
      zle accept-line
    fi
    rm -f "$tmp"
  fi
  zle reset-prompt
}

function fzf-find-file() {
  local file
  local -a fd_excludes
  fd_excludes=("${(@)fzf_exclude_dirs/#/--exclude=}")
  file=$(fd --type f --hidden "${fd_excludes[@]}" | fzf --preview "bat --color=always --style=header,grid --line-range :200 {}")
  if [ -n "$file" ]; then
    BUFFER="${EDITOR:-vi} ${(q)file}"
    zle accept-line
  fi
  zle reset-prompt
}

function fzf-live-grep() {
  local selected
  selected=$(
    rg --line-number --no-heading --smart-case . 2>/dev/null | \
      fzf --delimiter : \
          --preview 'bat --color=always --style=header,grid --highlight-line {2} {1}' \
          --preview-window '~4,+{2}+4/3,<80(up)'
  )
  if [ -n "$selected" ]; then
    local file line
    file="${selected%%:*}"
    line="${${selected#*:}%%:*}"
    BUFFER="${EDITOR:-vi} +${line:-1} ${(q)file}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf_select_directory_history
zle -N fzf_select_command_history
zle -N ghq-fzf
zle -N yazi-zle
zle -N fzf-find-file
zle -N fzf-live-grep


# JetBrainsのターミナル以外でbindkeyを設定
if [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
  bindkey "^x^r" fzf_select_directory_history
  bindkey "^r" fzf_select_command_history
  bindkey "^x^f" yazi-zle
  bindkey "^[sf" fzf-find-file
  bindkey "^[sr" fzf-live-grep
  bindkey "^xp" ghq-fzf
fi
