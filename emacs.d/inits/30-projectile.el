(use-package projectile-rails
           :ensure t)
(use-package projectile
  :ensure t
  :init
  (add-hook 'projectile-mode-hook 'projectile-rails-on)
  (projectile-global-mode)
  )

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  )

(provide 'setup-projectile)
