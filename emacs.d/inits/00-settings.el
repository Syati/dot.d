;;; -*- lexical-binding: t -*-
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

;; 最近開いたファイルを記録 (consult-recent-file 等が使う)
(recentf-mode 1)

;; 対応する括弧をハイライト
(setq show-paren-delay 0)
(show-paren-mode t)

;; デバッグモード
;;(setq debug-on-error t)

;; Emacs の質問を y/n に
(setq use-short-answers t)

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

;; toolbar setting (global minor mode。表示の有無に関係なく無効化できる)
(tool-bar-mode 0)

;; タイトルバー透過・ダーク表示・スクロールバー非表示・余白なし
;;
;; daemon 起動時は window-system/display-graphic-p が nil のため、
;; ここを起動時に一度だけ判定すると daemon 経由のフレームに適用されない。
;; フォント設定 (94-font.el) と同様、emacsclient -c で新しいフレームを
;; 作るたびに (再)適用する。
(defun my/setup-frame-appearance (&optional frame)
  (when (memq (framep-on-display frame) '(mac ns))
    ;; emacsclient で作った直後のフレームにすぐ適用しても反映されないため、
    ;; フレーム初期化が終わるのを待ってから適用する。
    (run-with-timer
     0.3 nil
     (lambda ()
       (modify-frame-parameters
        frame
        '((ns-transparent-titlebar . t)
          (vertical-scroll-bars . nil)
          (ns-appearance . dark) ;; 26.1 {light, dark}
          (internal-border-width . 0)
          (alpha 90 70)))))))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'my/setup-frame-appearance)
  (my/setup-frame-appearance))

;; ediff
;(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; tab indent setting
(setq c-auto-newline t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-basic-offset 4)
(setq c-default-style
      '((java-mode . "java") (awk-mode . "awk") (other . "linux")))

;; 保存時ホワイトスペース削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; trash setting
(setq delete-by-moving-to-trash t)
(setq trash-directory "~/.Trash")
