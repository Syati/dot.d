(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)

  (setq-default flycheck-temp-prefix ".")
  (setq flycheck-eslintrc "~/.eslintrc")

  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (flycheck-add-mode 'javascript-eslint 'js-mode)

  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))

  )


(provide '30-flycheck)
;;; 30-flycheck ends here
