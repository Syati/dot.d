(use-package js2-mode
  :ensure t
  :init
  (add-hook 'js2-mode-hook 'tern-mode)
  (add-hook 'js2-mode-hook 'flycheck-mode)
  (add-hook 'js2-jsx-mode-hook 'tern-mode)
  (add-hook 'js2-jsx-mode-hook 'flycheck-mode)
  :mode (("\\.js\\'"  . js2-mode)
         ("\\.jsx\\'" . js2-jsx-mode))         
  :config
  (setq js2-basic-offset 2)
  (custom-set-variables '(js2-strict-trailing-comma-warning nil))
  )

;;; 20-javascript ends here
