# mise の shims を PATH に載せる (/etc/sandbox-persistent.sh から source される)
command -v mise >/dev/null 2>&1 && export PATH="$HOME/.local/share/mise/shims:$PATH"
