(use-package mozc
  :ensure t
  :defer t
  :init
  (bind-keys* ("C-/"     . mozc-mode))
  :config
  (use-package mozc-popup :ensure t)
  (set-language-environment "Japanese")
  (setq default-input-method "japanese-mozc")
  (setq mozc-candidate-style 'popup)
  )


