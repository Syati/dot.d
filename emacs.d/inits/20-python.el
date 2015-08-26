(when (require 'elpy nil t)
  (elpy-enable)
  (setq python-check-command "flake8")
  (setq elpy-rpc-backend "jedi")
  )

(add-hook 'python-mode-hook
          '(lambda ()
             (origami-mode t)
             ))
;; python
;;(require 'ac-python) 

;;(add-hook 'python-mode-hook 'jedi:ac-setup)
;;(setq jedi:setup-keys t)


