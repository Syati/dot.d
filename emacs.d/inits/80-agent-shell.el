;;; -*- lexical-binding: t -*-
;; Claude Code 用の ACP アダプタが別途必要:
;; https://github.com/agentclientprotocol/claude-agent-acp
;; 認証は agent-shell-anthropic-authentication のデフォルト (:login t) で
;; 既存の claude CLI のログインをそのまま使う。
(use-package agent-shell
  :ensure t
  :defer t
  :bind ("C-c C-a" . agent-shell-anthropic-start-claude-code))
