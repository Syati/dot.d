;; automatically clean up bad whitespace
(use-package coffee-mode
  :ensure t
  :defer t  
  :init
  (add-hook 'coffee-mode-hook
            '(lambda ()
               (setq flycheck-checker 'coffee-coffeelint)
               (tern-mode t)
               (origami-mode t)
               (flycheck-mode t)
               (add-to-list 'ac-dictionary-files "~/.emacs.d/ac-dict/js2-mode")
               ))
  :config
  (setq whitespace-action '(auto-cleanup))
  ;; only show bad whitespace
  (setq whitespace-style '(trailing
                           space-before-tab
                           indentation
                           empty
                           space-after-tab))
  (custom-set-variables '(coffee-tab-width 2))
  )

