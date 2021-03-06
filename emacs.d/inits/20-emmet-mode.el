;; emmet-mode
(use-package emmet-mode
  :ensure t
  :init
  (add-hook 'web-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
  :bind (:map emmet-mode-keymap
              ("C-j" . nil)
              ("<M-return>"  . emmet-expand-line)
              ("<C-return>" . emmet-expand-yas))
  :config
  (setq emmet-indentation 2)
  (setq emmet-move-cursor-between-quotes t)
  )
