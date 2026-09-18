;;; -*- lexical-binding: t -*-
;; agent-shell 系のコマンドは 80-agent-shell.el で C-c C-a 等の直接バインドも
;; 用意しているが、使用頻度の低いものまで含めて一覧から呼べるよう
;; tabspaces 用 (30-tabspaces-transient.el) と同じ形式で transient にまとめる。

(require 'transient)

(transient-define-prefix my/agent-shell-transient ()
  "Agent shell commands."
  [["Start"
    ("a" "Claude Code"           agent-shell-anthropic-start-claude-code)
    ("o" "Codex"                 agent-shell-openai-start-codex)
    ("n" "New shell"             agent-shell-new-shell)
    ("f" "Fork"                  agent-shell-fork)
    ("R" "Restart (fresh)"       agent-shell-restart)
    ("L" "Reload (same session)" agent-shell-reload)]
   ["Buffer"
    ("b" "Switch buffer" agent-shell-switch-buffer)
    ("O" "Other buffer"  agent-shell-other-buffer)]
   ["Send"
    ("s" "Send file"            agent-shell-send-file)
    ("r" "Send region to..."    agent-shell-send-region-to)
    ("i" "Send clipboard image" agent-shell-send-clipboard-image)
    ("S" "Send screenshot"      agent-shell-send-screenshot)]
   ["Control"
    ("k" "Interrupt"        agent-shell-interrupt)
    ("c" "Copy last output" agent-shell-copy-last-output)
    ("l" "Toggle logging"   agent-shell-toggle-logging)]])

(global-set-key (kbd "s-a") #'my/agent-shell-transient)
