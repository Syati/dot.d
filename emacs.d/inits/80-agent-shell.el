;;; -*- lexical-binding: t -*-
;; Claude Code 用の ACP アダプタが別途必要:
;; https://github.com/agentclientprotocol/claude-agent-acp
;; 認証は agent-shell-anthropic-authentication のデフォルト (:login t) で
;; 既存の claude CLI のログインをそのまま使う。
;;
;; use-package-ensure-system-package は MELPA から配信されていないため
;; package-vc-install で GitHub から直接入れる。
(use-package system-packages
  :ensure t)
(unless (package-installed-p 'use-package-ensure-system-package)
  (package-vc-install "https://github.com/waymondo/use-package-ensure-system-package"))
(require 'use-package-ensure-system-package)

(use-package agent-shell
  :ensure t
  :defer t
  :ensure-system-package
  ((claude . "brew install claude-code")
   (claude-agent-acp . "npm install -g @agentclientprotocol/claude-agent-acp"))
  :init
  (setq agent-shell-session-restore-verbosity 'full)
  :bind (("C-c C-a" . agent-shell-anthropic-start-claude-code)
         ("C-c C-w" . agent-shell)
         ("C-c C-l" . agent-shell-restart)
  ))
