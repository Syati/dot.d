(use-package yasnippet
  :ensure t  
  :init
  (use-package dropdown-list)
  :bind (:map yas-keymap
              ("C-n" . yas-next-field-or-maybe-expand)
              ("C-p" . yas-prev)
              ("TAB" . nil)
              ("tab" . nil)
              ("shift tab" . nil)
              ("backtab"   .  nil)
              :map yas-minor-mode-map
              ("<C-tab>" . yas-expand)
              ("TAB" . nil)
              ("tab" . nil))
  :config
  (add-to-list 'yas/root-directory "~/.emacs.d/snippets")

  (setq yas-prompt-functions '(yas-dropdown-prompt
                               yas-ido-prompt
                               yas-completing-prompt
                               ))
  )


