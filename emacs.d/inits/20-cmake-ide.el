(use-package cmake-mode
  :init
  (add-hook 'cmake-mode-hook 'auto-complete-mode)
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
  )
