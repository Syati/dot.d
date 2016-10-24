(use-package ruby-mode
  :config
  (use-package robe
    :ensure t
    :config
    (add-hook 'robe-mode-hook 'ac-robe-setup))
  
  (add-hook 'ruby-mode-hook 'robe-mode)  
  )

;; python
;;(require 'ac-python) 

;;(add-hook 'python-mode-hook 'jedi:ac-setup)
;;(setq jedi:setup-keys t)


