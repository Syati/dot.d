(use-package flycheck
  :ensure t
  :defer t
  :init
  (setq-default flycheck-temp-prefix "."
                flycheck-eslintrc "~/.eslintrc")
  :config
  (global-flycheck-mode))










