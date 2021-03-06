;; multi-web-mode
(use-package multi-web-mode
  :ensure t
  :defer t
  :init
  (setq mweb-default-major-mode 'web-mode)
  (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                    (js2-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                    (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
  (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5" "ejs"))
  (multi-web-global-mode 1)
  )
