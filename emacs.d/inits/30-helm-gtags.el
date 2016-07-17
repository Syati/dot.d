(use-package helm-gtags
  :defer t  
  :init
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  (add-hook 'asm-mode-hook 'helm-gtags-mode)
  (add-hook 'php-mode-hook 'helm-gtags-mode)
  :config
  (custom-set-variables
   '(helm-gtags-path-style 'relative)
   '(helm-gtags-ignore-case t)
   '(helm-gtags-auto-update t))
  (bind-keys :map helm-gtags-mode-map
             ("M-t" . helm-gtags-find-tag)
             ("M-r" . helm-gtags-find-rtag)
             ("M-s" . helm-gtags-find-symbol)
             ("M-g M-p" . helm-gtags-parse-file)
             ("C-c <" . helm-gtags-previous-history)
             ("C-c >" . helm-gtags-next-history)
             ("M-,"  . helm-gtags-pop-stack))
  )
