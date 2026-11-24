# Docker Sandboxes (sbx) を dev-tools kit つきで起動する
# 使い方: sbxc [PATH]  (Claude) / sbxx [PATH]  (Codex)。PATH 省略時はカレントディレクトリ
# サンドボックス名は sbx の自動命名 <agent>-<ディレクトリ名>。
# 既存なら再アタッチ (--kit は新規作成時のみ有効)、なければ kit つきで作成する。
# git の名前・メール・署名は kit (git-identity / ssh-agent ケイパビリティ) がホストから渡す。
_sbx_dev_tools_kit="${HOME}/.dot.d/sbx/kits/dev-tools"

_sbx_run_with_kit() {
  local agent="$1" dir="${2:-.}"
  local basename="${${dir:A}:t}" suffix='' char
  for char in ${(s::)basename}; do
    if [[ "$char" == [a-zA-Z0-9] ]]; then
      suffix+="$char"
    elif [[ -n "$suffix" && "$suffix[-1]" != - ]]; then
      suffix+='-'
    fi
  done
  suffix="${suffix%-}"
  [[ -n "$suffix" ]] || suffix='workspace'
  # sbx names are limited to 63 ASCII characters.
  local name="${agent}-${suffix[1,$((62 - ${#agent}))]}"
  if ! sbx ls 2>/dev/null | awk 'NR>1{print $1}' | grep -qx -- "$name"; then
    sbx create "$agent" "$dir" --kit "${_sbx_dev_tools_kit}" || return
  fi
  # sbx はエージェントを VM の中で動かすため、Herdr からは `sbx` しか見えず agent 一覧に出ない。
  # HERDR_AGENT で「このコマンドは <agent> の画面」と教える（このコマンドのプロセスにだけ効く）。
  HERDR_AGENT="$agent" sbx run --name "$name"
}

sbxc() { _sbx_run_with_kit claude "$@" }
sbxx() { _sbx_run_with_kit codex "$@" }
