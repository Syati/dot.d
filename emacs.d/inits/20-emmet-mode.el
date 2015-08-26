;; emmet-mode
(require 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent 2 spaces.
(setq emmet-move-cursor-between-quotes t)

(define-key emmet-mode-keymap (kbd "C-j") nil)
(define-key emmet-mode-keymap (kbd "<M-return>") 'emmet-expand-line)
(define-key emmet-mode-keymap (kbd "<C-return>") 'emmet-expand-yas)
