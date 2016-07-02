(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)

  (setq-default flycheck-temp-prefix ".")
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
  (when (executable-find "eslint")
    (setq flycheck-checker 'javascript-eslint))
  (setq flycheck-eslintrc "~/.eslintrc")
  )


(provide '30-flycheck)
;;; 30-flycheck ends here
