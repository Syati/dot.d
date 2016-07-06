(use-package auto-complete
  :ensure t
  :init
  (use-package auto-complete-config)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  :bind (:map ac-menu-map
              ("C-n" . ac-next)
              ("C-p" . ac-previous))
  :config
  (ac-config-default)
  (setq ac-auto-start t)
  (setq ac-use-menu-map t)
  (global-auto-complete-mode t)
  (ac-set-trigger-key "TAB")
  (ac-set-trigger-key "<tab>")
  )

