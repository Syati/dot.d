(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js2-basic-offset 2)

(add-hook 'js2-mode-hook
          (lambda ()
            (tern-mode t)
            (define-key tern-mode-keymap [(C-tab)] 'tern-ac-complete)))

(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))



