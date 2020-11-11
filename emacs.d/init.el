;================================;
; use common lisp                ;
;================================;
;; (require 'cl) を見逃す
(setq byte-compile-warnings '(not cl-functions obsolete))

(require 'cl)

;================================;
; path                           ;
;================================;

;; load path
(let ((default-directory (expand-file-name "~/.emacs.d/site-lisp")))
  (add-to-list 'load-path default-directory)
  (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
      (normal-top-level-add-subdirs-to-load-path)))


;================================;
; package                        ;
;================================;
(require 'package)
(package-initialize)

;; package archives
(setq package-archives '(("ELPA" . "https://tromey.com/elpa/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))


(defvar installing-package-list
  '(
    ;; ここに使っているパッケージを書く。
    init-loader
    use-package
    ;; 開発補助
    origami
    magit
    magit-annex
    magit-filenotify
    magit-find-file
    magit-gerrit
    magit-gh-pulls
    magit-gitflow
    magit-stgit
    magit-svn
    magit-topgit
    flycheck
    flycheck-cask
    flycheck-color-mode-line
    flycheck-pos-tip
    flycheck-pyflakes
    ;; 開発モード
    ;; typescript
    typescript-mode
    tide
    ;;; c
    cmake-mode
    cmake-ide
    ;;; python
    elpy
    python-environment
    pyvenv
    ;;; haskell
    haskell-mode
    ;;; js
    js2-mode
    tern
    coffee-mode
    jade-mode
    json-mode
    json-reformat
    ;;; markdown
    markdown-mode
    markdown-mode+
    ;;; docker
    dockerfile-mode
    php-mode
    ;;: web
    web-mode
    ;;;; less
    less-css-mode
    ;; org
    org
    ;; emacs 拡張
    image+
    migemo
    recentf-ext
    swap-buffers
    switch-window
    ;; el-get turn-off
    ag
    wgrep-ag
    undohist
    wgrep
    sequential-command
    multiple-cursors
    popwin
    ;;dire 拡張
    direx
    jedi-direx
    ;; shell
    multi-term
    ;; helm
    helm
    helm-ag
    helm-swoop
    helm-c-moccur
    helm-c-yasnippet
    helm-descbinds
    helm-dictionary
    helm-dired-recent-dirs
    helm-emmet
    helm-flycheck
    helm-git-files
    helm-git-grep
    helm-gtags
    helm-ag-r
    helm-projectile
    wgrep-helm
    all-ext
    ;;
    projectile
    ;;theme(display)
    monokai-theme
    ;; japanese
    mozc
    mozc-popup
   ))

(let ((not-installed (loop for x in installing-package-list
                            when (not (package-installed-p x))
                            collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
        (package-install pkg))))



;================================;
; initial use-package            ;
;================================;

(require 'use-package)

; speed check
;(use-package initchart)
;(initchart-record-execution-time-of load file)
;(initchart-record-execution-time-of require feature)

(use-package init-loader
  :init
  (setq init-loader-show-log-after-init nil)
  (setq init-loader-byte-compile t)
  (init-loader-load "~/.emacs.d/inits")
  )



;================================;
; misc                           ;
;================================;

;;; 一行あたりの文字数を指定してfill-region
(defun fill-region-with-N (num)
  ""
  (interactive "fill-column value? ")
  (let ((fill-column num))
    (fill-region (region-beginning) (region-end)))
  )

;; other-window
(defun other-window-backward ()
  "move to other window backward"
  (interactive)
  (other-window -1))

(defun reopen-with-sudo ()
  "Reopen current buffer-file with sudo using tramp."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name
        (find-alternate-file (concat "/sudo::" file-name))
      (error "Cannot get a file name"))))
