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
  :bind (("C-c C-a" . agent-shell-anthropic-start-claude-code)
         ("C-c C-o" . agent-shell-openai-start-codex)
         ("C-c C-w" . agent-shell)
         ("C-c C-l" . agent-shell-restart)
  ))
