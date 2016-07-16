(use-package magit
  :ensure t
  :defer t
  :init
  (bind-keys* ("C-x g" . magit-status)
              ("C-x M-g" . magit-dispatch-popup))
  )

