(setq default-directory "~/" )
(setq initial-buffer-choice default-directory)

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


(when (memq window-system '(mac ns))
  (setq initial-frame-alist
        (append
         '((ns-transparent-titlebar . t) ;; タイトルバーを透過
           (vertical-scroll-bars . nil) ;; スクロールバーを消す
           (ns-appearance . dark) ;; 26.1 {light, dark}
           (internal-border-width . 0)
           (alpha 90 70)
           )))
  ) ;; 余白を消す
(setq default-frame-alist initial-frame-alist)

;; ediff
;(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; tab indent setting
(setq c-auto-newline t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq default-tab-width 4)
(setq c-basic-offset 4)
(setq c-default-style
      '((java-mode . "java") (awk-mode . "awk") (other . "linux")))

;; 保存時ホワイトスペース削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; trash setting
(custom-set-variables
 '(delete-by-moving-to-trash t)
 '(trash-directory "~/.Trash"))
