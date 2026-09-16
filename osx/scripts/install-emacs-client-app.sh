#!/bin/sh
# emacs --daemon 経由で GUI フレームを開くためのランチャーアプリを作る。
# Alfred/Spotlight から「Emacs Client」として呼び出せるようになる。
# 既に GUI フレームがあれば使い回し、無ければ emacsclient -c で新規作成する。
set -eu

APP="$HOME/Applications/Emacs Client.app"
SCRIPT="$(mktemp /tmp/emacs-client-launcher.XXXXXX.applescript)"
trap 'rm -f "$SCRIPT"' EXIT

cat > "$SCRIPT" <<'EOF'
do shell script "TMPDIR=$(getconf DARWIN_USER_TEMP_DIR); SOCK=\"$TMPDIR/emacs$(id -u)/server\"; EXISTING=$(/opt/homebrew/bin/emacsclient --socket-name=\"$SOCK\" -e '(seq-find (lambda (fr) (memq (framep-on-display fr) (quote (ns mac)))) (frame-list))' 2>/dev/null); if [ \"$EXISTING\" != \"nil\" ] && [ -n \"$EXISTING\" ]; then /opt/homebrew/bin/emacsclient --socket-name=\"$SOCK\" -e '(let ((f (seq-find (lambda (fr) (memq (framep-on-display fr) (quote (ns mac)))) (frame-list)))) (make-frame-visible f) (raise-frame f) (select-frame-set-input-focus f))' >/tmp/emacsclient-launch.log 2>&1; else /opt/homebrew/bin/emacsclient --socket-name=\"$SOCK\" -c -n -a '' >/tmp/emacsclient-launch.log 2>&1; fi; osascript -e 'tell application \"Emacs\" to activate'"
EOF

mkdir -p "$HOME/Applications"
rm -rf "$APP"
osacompile -o "$APP" "$SCRIPT"
echo "Installed: $APP"
