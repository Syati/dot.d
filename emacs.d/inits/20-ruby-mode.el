(use-package rbenv
  :ensure t
  :defer t
  :init
  (global-rbenv-mode)
  )

(use-package inf-ruby
  :ensure t
  :defer t
  :init
  (setq inf-ruby-default-implementation "pry")
  )

(use-package robe
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'ruby-mode-hook 'robe-mode)
    (eval-after-load 'company
      '(push 'company-robe company-backends))
    )
  )

;;    (add-hook 'ruby-mode-hook 'company-mode)
;;    (with-eval-after-load 'company
;;      (add-to-list 'company-backends 'company-robe))))
