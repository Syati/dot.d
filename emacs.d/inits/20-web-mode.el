(use-package web-mode
  :ensure t
  :defer t
  :mode (("\\.erb$" . web-mode)
         )
  :config 
  (setq web-mode-markup-indent-offset 2) ;; html indent
  (setq web-mode-css-indent-offset 2) ;; css indent
  (setq web-mode-code-indent-offset 2) ;; script indent(js,php,etc..)
  (setq indent-tabs-mode nil)

  (eval-after-load "sgml-mode"
    '(define-key html-mode-map (kbd "C-c C-d") 'ng-snip-show-docs-at-point))

  (define-key web-mode-map (kbd "C-c C-v") 'browse-url-of-buffer)
  )

