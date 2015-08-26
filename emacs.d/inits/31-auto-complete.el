(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")

(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
(define-key ac-menu-map "C-n" 'ac-next)
(define-key ac-menu-map "C-p" 'ac-previous)

(setq ac-auto-start t)
(setq ac-use-menu-map t)
(global-auto-complete-mode t)


(defun ac-common-setup ()
  (setq ac-sources (append ac-sources '(ac-source-gtags))))


(add-to-list 'ac-modes 'coffee-mode) ;; coffee-modeでACを使えるようにする

