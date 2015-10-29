(require 'yasnippet)
(require 'angular-snippets)
(require 'dropdown-list)

(add-to-list 'yas/root-directory "~/.emacs.d/snippets")
;;(define-key yas-minor-mode-map (kbd "C-tab") 'yas-expand)
;;(define-key yas-minor-mode-map (kbd "M-o") 'yas-insert-snippet)
;;(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;;(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)
(define-key yas-minor-mode-map [(C-tab)] 'yas-expand)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)

;;keys for navigation
(define-key yas-keymap [(tab)]       nil)
(define-key yas-keymap (kbd "TAB")   nil)
(define-key yas-keymap [(shift tab)] nil)
(define-key yas-keymap [backtab]     nil)
(define-key yas-keymap (kbd "C-n") 'yas-next-field-or-maybe-expand)
(define-key yas-keymap (kbd "C-p") 'yas-prev)


(setq yas-prompt-functions '(yas-dropdown-prompt
                             yas-ido-prompt
                             yas-completing-prompt
                             ))

(yas-global-mode 1)
