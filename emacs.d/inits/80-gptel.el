;;; -*- lexical-binding: t -*-
;; APIキーは ~/.authinfo(.gpg) に置く (gptel-api-key のデフォルトが
;; auth-source 経由で自動取得する):
;;   machine api.anthropic.com login apikey password sk-ant-...
(use-package gptel
  :ensure t
  :defer t
  :bind ("C-c g" . gptel)
  :config
  (setq gptel-backend (gptel-make-anthropic "Claude" :stream t))
  (setq gptel-model 'claude-sonnet-5))
