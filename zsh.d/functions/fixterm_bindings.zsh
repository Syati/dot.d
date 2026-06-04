# Ghostty/Fixterm(CSI-u) で送られる Ctrl 系キーを既存バインドに合わせる

function bind_fixterm_to_legacy_widget() {
  local legacy_key="$1"
  local fixterm_seq="$2"
  local keymap current_binding widget

  for keymap in emacs viins; do
    current_binding=$(bindkey -M "$keymap" "$legacy_key" 2>/dev/null) || continue
    widget=${current_binding##* }
    [[ -n "$widget" && "$widget" != undefined-key ]] || continue
    bindkey -M "$keymap" "$fixterm_seq" "$widget"
  done
}

bind_fixterm_to_legacy_widget '^A' '^[[97;5u'
bind_fixterm_to_legacy_widget '^B' '^[[98;5u'
bind_fixterm_to_legacy_widget '^D' '^[[100;5u'
bind_fixterm_to_legacy_widget '^E' '^[[101;5u'
bind_fixterm_to_legacy_widget '^F' '^[[102;5u'
bind_fixterm_to_legacy_widget '^H' '^[[104;5u'
bind_fixterm_to_legacy_widget '^I' '^[[105;5u'
bind_fixterm_to_legacy_widget '^J' '^[[106;5u'
bind_fixterm_to_legacy_widget '^K' '^[[107;5u'
bind_fixterm_to_legacy_widget '^N' '^[[110;5u'
bind_fixterm_to_legacy_widget '^P' '^[[112;5u'
bind_fixterm_to_legacy_widget '^R' '^[[114;5u'
bind_fixterm_to_legacy_widget '^T' '^[[116;5u'
bind_fixterm_to_legacy_widget '^U' '^[[117;5u'
bind_fixterm_to_legacy_widget '^W' '^[[119;5u'
bind_fixterm_to_legacy_widget '^Y' '^[[121;5u'
bind_fixterm_to_legacy_widget '^[' '^[[91;5u'
bind_fixterm_to_legacy_widget '^]' '^[[93;5u'
bind_fixterm_to_legacy_widget '^M' '^[[109;5u'
