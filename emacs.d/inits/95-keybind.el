;;; -*- lexical-binding: t -*-
;; Cmd+C/Cmd-V 等のOSパススルーは使っていないので、左CmdもSuperとして
;; Emacs側で使う。kill-ring と yank は select-enable-clipboard (デフォルト
;; t) でシステムクリップボードと連携済みなので、コピペ自体は M-w / C-y の
;; ままで問題ない。
(setq mac-command-modifier 'super)
;; 以前 karabiner+右Cmd を Hyper にしていた名残。setq を消しても
;; 既存セッションの変数値は元に戻らない (defcustom の初期値には
;; リセットされない) ので、'left (= mac-command-modifier を継承) に
;; 明示的に戻す。
(setq mac-right-command-modifier 'left)

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
