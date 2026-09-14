;;; -*- lexical-binding: t -*-
(require 'dired-x)

(setq dired-dwim-target t)
(setq-default dired-omit-files-p t) ; this is buffer-local variable
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))

;; dired + wdired
;; 新規バッファで開いた際、遷移先も dired なら元のバッファを閉じる
(defvar my-dired-before-buffer nil)

(defun my-dired-remember-buffer (&rest _)
  (setq my-dired-before-buffer (current-buffer)))

(defun my-dired-kill-previous-buffer (&rest _)
  (when (eq major-mode 'dired-mode)
    (kill-buffer my-dired-before-buffer)))

(advice-add 'dired-advertised-find-file :before #'my-dired-remember-buffer)
(advice-add 'dired-advertised-find-file :after #'my-dired-kill-previous-buffer)
(advice-add 'dired-up-directory :before #'my-dired-remember-buffer)
(advice-add 'dired-up-directory :after #'my-dired-kill-previous-buffer)

(defvar my-dired-additional-compression-suffixes
  '(".7z" ".Z" ".a" ".ace" ".alz" ".arc" ".arj" ".bz" ".bz2" ".cab" ".cpio"
    ".deb" ".gz" ".jar" ".lha" ".lrz" ".lz" ".lzh" ".lzma" ".lzo" ".rar"
    ".rpm" ".rz" ".t7z" ".tZ" ".tar" ".tbz" ".tbz2" ".tgz" ".tlz" ".txz"
    ".tzo" ".war" ".xz" ".zip"))

(with-eval-after-load 'dired-aux
  (dolist (suffix my-dired-additional-compression-suffixes)
    (add-to-list 'dired-compress-file-suffixes
                 `(,(concat "\\" suffix "\\'") "" "aunpack"))))

;;; ファイル・ディレクトリ名のリストを編集することで、まとめてリネーム可能にする
(require 'wdired)
;;; wdiredモードに入るキー(下の例では「r」)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
;;; 新規バッファを作らずにディレクトリを開く(デフォルトは「a」)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
;;; 「a」を押したときに新規バッファを作って開くようにする
(define-key dired-mode-map "a" 'dired-advertised-find-file)
;;; 「^」がを押しにくい場合「b」でも上の階層に移動できるようにする
(define-key dired-mode-map "b" 'dired-up-directory)
(put 'dired-find-alternate-file 'disabled nil)
