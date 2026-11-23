# Docker Sandboxes (sbx) を dev-tools kit つきで起動する
# 使い方: sbxc [PATH]  (Claude) / sbxx [PATH]  (Codex)。PATH 省略時はカレントディレクトリ
# サンドボックス名は sbx の自動命名 <agent>-<ディレクトリ名>。
# 既存なら再アタッチ (--kit は新規作成時のみ有効)、なければ kit つきで作成する。
_sbx_dev_tools_kit="${HOME}/.dot.d/sbx/kits/dev-tools"

_sbx_run_with_kit() {
  local agent="$1" dir="${2:-.}"
  local name="${agent}-${${dir:A}:t}"
  if sbx ls 2>/dev/null | awk 'NR>1{print $1}' | grep -qx -- "$name"; then
    sbx run --name "$name"
  else
    sbx run "$agent" "$dir" --kit "${_sbx_dev_tools_kit}"
  fi
}

sbxc() { _sbx_run_with_kit claude "$@" }
sbxx() { _sbx_run_with_kit codex "$@" }
