(global-set-key (kbd "C-1") 'find-tag)
(global-set-key (kbd "C-2") 'pop-tag-mark)
(global-set-key (kbd "C-q") 'dabbrev-expand)
(global-set-key (kbd "C-h") 'delete-backward-char)
;; (global-set-key (kbd "C-o") 'switch-window)
(global-set-key (kbd "C-S-o") 'switch-window-backward)
(global-set-key (kbd "C-x q") 'quoted-insert)
(global-set-key (kbd "C-x C-d") 'nav-toggle)
(global-set-key (kbd "C-c C-r") 'revert-buffer)
(global-set-key (kbd "C-c C-e") 'eval-current-buffer)
(global-set-key (kbd "C-x r t") 'inline-string-rectangle)
(global-set-key (kbd "C-x M-t") 'text-translator)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-project-directory)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "M-g") 'goto-line)
;; (global-set-key (kbd "C-*") 'mark-all-like-this-in-region)
;; (global-set-key (kbd "C-M-m") 'mark-more-like-this) ; like the other two, but takes an argument (negative is previous)
(global-set-key (kbd "C-.") 'dired-omit-mode)
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "C-x C-z") nil)

(global-set-key (kbd "M-p") 'flymake-goto-prev-error)
(global-set-key (kbd "M-n") 'flymake-goto-next-error)
(global-set-key (kbd "<C-M-return>") 'multi-term-dedicated-toggle)

(global-set-key [f9] 'linum-mode)
(global-set-key (kbd "C-q C-q") 'quoted-insert)
