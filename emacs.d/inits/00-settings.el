(setq default-directory "~/" )

;; recentf
(setq recentf-max-saved-items nil)

;; backup settings
(setq make-backup-files t)
(setq backup-directory-alist
  (cons (cons ".*" (expand-file-name "~/.emacs.d/backup"))
    backup-directory-alist))

(setq auto-save-file-name-transforms
  `((".*", (expand-file-name "~/.emacs.d/backup/") t)))

;; 編集時 buffer 再読み込み
(global-auto-revert-mode 1)

;; 対応する括弧をハイライト
(setq show-paren-delay 0)
(show-paren-mode t)

;; デバッグモード
;;(setq debug-on-error t)

;; Emacs の質問を y/n に
(fset 'yes-or-no-p 'y-or-n-p)

;; シンボリックリンクを開くときの質問省略
(setq vc-follow-symlinks t)

;; linum-mode をいじって Emacs を高速化
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))

;; カーソルの位置が何文字目かを表示する
(column-number-mode t)

;; startup-message off
(setq inhibit-startup-message t)
;;(dired "~/");

;; ignore the difference between capital letter and small letter
;; (setq completion-ignore-case t)

;; toggle delete-region 
(delete-selection-mode t)

;; 通常のウィンドウで行を折り返さない
(set-default 'truncate-lines t)

;; コメントアウトの形式変更
(setq comment-style 'multi-line)

;; invalid next-line when buffer is end
(setq next-line-add-newlines nil)

;; toolbar setting
(if (display-graphic-p)
    (progn 
      (tool-bar-mode 0)
      ))

(scroll-bar-mode -1)

;; frame opacity setting
(set-frame-parameter (selected-frame) 'alpha '(90 70))
(add-to-list 'default-frame-alist '(alpha 90 70))

;; ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; tab indent setting
(setq c-auto-newline t)
(setq-default indent-tabs-mode nil)  
(setq-default tab-width 4)
(setq default-tab-width 4)
(setq c-basic-offset 4)
(setq c-default-style
      '((java-mode . "java") (awk-mode . "awk") (other . "linux")))

;; trash setting
(custom-set-variables
 '(delete-by-moving-to-trash t)
 '(trash-directory "~/.Trash"))
