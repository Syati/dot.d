(use-package tern
  :commands (tern-auto-complete)
  :config
  (tern-ac-setup)   
  (bind-keys :map tern-mode-keymap
             ([(C-tab)] . tern-ac-complete))
  )

(provide '31-tern-mode)
;;; 31-tern-mode ends here
