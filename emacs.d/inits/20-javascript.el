(use-package js2-mode
  :init
  (add-hook 'js2-mode-hook 'tern-mod)
  (add-hook 'js2-mode-hook 'flycheck-mode)
  :mode (("\\.js\\'"  . js2-mode))
  :config
  (setq js2-basic-offset 2)
  )

(use-package js2-jsx-mode
  :init
  (add-hook 'js2-jsx-mode-hook 'tern-mod)
  (add-hook 'js2-jsx-mode-hook 'flycheck-mode)
  :mode (("\\.jsx\\'" . js2-jsx-mode))
  :config
  (setq js2-basic-offset 2)
  )

(provide '20-javascript)
;;; 20-javascript ends here
