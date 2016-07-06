;; rst.elを読み込み
(use-package rst
  :ensure t
  :mode (("\\.rst$" . rst-mode)
         ("\\.rest$" . rst-mode))
  :config
  (setq frame-background-mode 'dark)
  (setq indent-tabs-mode nil)
  )

