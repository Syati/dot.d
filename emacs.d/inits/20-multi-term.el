(require 'multi-term)
(setq multi-term-program shell-file-name)
(setq term-buffer-maximum-size 0)

(add-to-list 'term-unbind-key-list "C-]")
(add-to-list 'term-unbind-key-list "C-t")
(add-to-list 'term-unbind-key-list "C-o")

(add-hook 'term-mode-hook
          (lambda ()
            (setq term-buffer-maximum-size 1000000)
            (add-to-list 'term-bind-key-alist '("M-[" . multi-term-prev))
            (add-to-list 'term-bind-key-alist '("M-]" . multi-term-next))
            (define-key term-raw-map (kbd "C-y") 'term-paste)
            (define-key term-raw-map (kbd "C-h") 'term-send-backspace)
            (define-key term-raw-map (kbd "M-d") 'term-send-forward-kill-word)
            (define-key term-raw-map (kbd "C-v") nil)
            (define-key term-raw-map (kbd "ESC ESC") 'term-send-raw)
            (define-key term-raw-map (kbd "C-q") 'toggle-term-view)
            (define-key term-raw-map (kbd "M-p")
              (lambda ()
                "history-beginning-search-backward-end"
                (interactive)
                (term-send-raw-string "ALT+P")))
            (define-key term-raw-map (kbd "M-n")
              (lambda ()
                "history-beginning-search-forward-end"
                (interactive)
                (term-send-raw-string "ALT+N")))))


(setq multi-term-dedicated-window-height 13)
(setq multi-term-dedicated-select-after-open-p t)

