;;; -*- lexical-binding: t -*-
(setq mac-command-modifier nil)

(global-set-key (kbd "C-1") 'find-tag)
(global-set-key (kbd "C-2") 'pop-tag-mark)
(global-set-key (kbd "C-q") 'dabbrev-expand)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-x q") 'quoted-insert)
(global-set-key (kbd "C-c C-r") 'revert-buffer)
(global-set-key (kbd "C-c C-e") 'eval-current-buffer)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-.") 'dired-omit-mode)
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "C-x C-z") nil)

(global-set-key (kbd "M-p") 'flymake-goto-prev-error)
(global-set-key (kbd "M-n") 'flymake-goto-next-error)

(global-set-key [f9] 'display-line-numbers-mode)

(defun my/reload-init ()
  "Reload ~/.emacs.d/init.el (re-runs init-loader-load)."
  (interactive)
  (load-file (expand-file-name "~/.dot.d/emacs.d/init.el")))

(global-set-key (kbd "C-z r") #'my/reload-init)
(global-set-key (kbd "C-z q") 'quoted-insert)
