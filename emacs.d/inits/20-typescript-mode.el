(use-package typescript-mode
  :ensure t
  :defer t
  :mode (("\\.tsx?\\'" . typescript-mode))
  :config
  (use-package flycheck)
  (use-package company)
  (use-package tide)
  (add-hook 'typescript-mode-hook 'setup-tide-mode)
  )

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode t)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode t)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  (company-mode t)
  (setq company-tooltip-align-annotations t)
  )
