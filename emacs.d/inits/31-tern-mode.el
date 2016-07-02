(use-package tern
  :commands (tern-auto-complete)
  :init
  (bind-key [(C-tab)] 'tern-ac-complete)
  (tern-ac-setup)
  )

(provide '31-tern-mode)
;;; 31-tern-mode ends here
