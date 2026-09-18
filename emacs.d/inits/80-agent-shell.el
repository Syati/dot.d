;;; -*- lexical-binding: t -*-
;; Claude Code / Codex それぞれ用の ACP アダプタが別途必要:
;; https://github.com/agentclientprotocol/claude-agent-acp
;; https://github.com/agentclientprotocol/codex-acp
;; 認証はどちらもデフォルトの (:login t) で、既存の claude / codex CLI の
;; ログインをそのまま使う (agent-shell-anthropic-authentication /
;; agent-shell-openai-authentication)。
;; :ensure-system-package のセットアップは 10-use-package-ensure-system-package.el 参照。

(use-package agent-shell
  :ensure t
  :defer t
  :ensure-system-package
  ((claude . "brew install claude-code")
   (claude-agent-acp . "npm install -g @agentclientprotocol/claude-agent-acp")
   (codex . "npm install -g @openai/codex")
   (codex-acp . "npm install -g @agentclientprotocol/codex-acp")
   (pngpaste . "brew install pngpaste"))
  :init
  (setq agent-shell-session-restore-verbosity 'full)
  ;; 30-agent-shell-transient.el から呼ぶが autoload cookie が無いコマンド群
  ;; (package 側で agent-shell-restart 等と違い autoload 未登録のため、
  ;; :defer t のままだと transient-setup が "not defined or autoloaded" で失敗する)
  :commands (agent-shell-switch-buffer
             agent-shell-other-buffer
             agent-shell-send-file
             agent-shell-send-region-to
             agent-shell-send-clipboard-image
             agent-shell-send-screenshot
             agent-shell-interrupt
             agent-shell-copy-last-output
             agent-shell-toggle-logging)
  :bind (("C-c C-a" . agent-shell-anthropic-start-claude-code)
         ("C-c C-o" . agent-shell-openai-start-codex)
         ("C-c C-w" . agent-shell)
         ("C-c C-l" . agent-shell-restart)
  ))
