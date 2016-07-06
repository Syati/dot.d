(use-package magit
  :ensure t
  :config
  (bind-keys* ("C-x g" . magit-status)
              ("C-x M-g" . magit-dispatch-popup))
  )

