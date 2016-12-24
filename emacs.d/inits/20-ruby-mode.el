(use-package inf-ruby
  :init 
  (setq inf-ruby-default-implementation "pry")
  )

(use-package robe
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'ruby-mode-hook 'robe-mode)
    (add-hook 'robe-mode-hook 'ac-robe-setup)))
;;    (add-hook 'ruby-mode-hook 'company-mode)
;;    (with-eval-after-load 'company
;;      (add-to-list 'company-backends 'company-robe))))
