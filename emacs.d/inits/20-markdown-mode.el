;; markdown-Mode
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(defun markdown-unset-tab ()
  "markdown-mode-hook"
  (define-key markdown-mode-map (kbd "<tab>") nil))
(add-hook 'markdown-mode-hook '(lambda() (markdown-unset-tab)))

(add-to-list 'auto-mode-alist '("\\.mdwn$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md$"   . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdt$"  . markdown-mode))
