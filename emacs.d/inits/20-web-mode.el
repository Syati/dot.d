(use-package web-mode
  :ensure t
  :defer t
  :config 
  (setq web-mode-markup-indent-offset 4) ;; html indent
  (setq web-mode-css-indent-offset 4) ;; css indent
  (setq web-mode-code-indent-offset 4) ;; script indent(js,php,etc..)
  (setq indent-tabs-mode nil)

  (eval-after-load "sgml-mode"
    '(define-key html-mode-map (kbd "C-c C-d") 'ng-snip-show-docs-at-point))

  (define-key web-mode-map (kbd "C-c C-v") 'browse-url-of-buffer)
  )

