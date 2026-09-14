;;; -*- lexical-binding: t -*-
;; 初回のみ M-x nerd-icons-install-fonts でフォントを入れる
(use-package nerd-icons
  :ensure t
  :if (display-graphic-p))

(use-package nerd-icons-completion
  :ensure t
  :after (nerd-icons marginalia)
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))
