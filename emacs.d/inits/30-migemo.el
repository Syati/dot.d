(when (and (executable-find "cmigemo")
           (require 'migemo nil t))
  (setq migemo-options '("-q" "--emaycs"))

  ;; Set your installed path
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
  
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init)
  (define-key isearch-mode-map (kbd "C-e") 'migemo-isearch-toggle-migemo)
)


