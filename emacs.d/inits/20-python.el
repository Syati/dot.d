(use-package elpy
  :commands (elpy-mode)
  :init
  (add-hook 'python-mode 'elpy-mode)
  (add-hook 'python-mode 'origami-mode)
  :config
  (elpy-enable)
  (setq python-check-command "flake8")
  (setq elpy-rpc-backend "jedi")
  )

;; python
;;(require 'ac-python) 

;;(add-hook 'python-mode-hook 'jedi:ac-setup)
;;(setq jedi:setup-keys t)


