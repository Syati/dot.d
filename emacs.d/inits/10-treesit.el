;;; -*- lexical-binding: t -*-
(use-package treesit
  :config
  (setq treesit-font-lock-level 4))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))
