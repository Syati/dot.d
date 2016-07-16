(use-package projectile
  :ensure t
  :init
  (projectile-global-mode)
  )

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  )

(provide 'setup-projectile)

