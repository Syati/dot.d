;================================;
; use common lisp                ;
;================================;

(require 'cl)
;(require 'cl-macs)

;================================;
; package                        ;
;================================;
(require 'package)
(package-initialize)

;; package archives
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

(defvar installing-package-list
  '(
    ;; ここに使っているパッケージを書く。
    init-loader
    use-package
    ;; 開発補助
    origami
    auto-complete-clang
    auto-complete
    gtags
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
    magit-tramp
    git-gutter
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
    tern-auto-complete
    coffee-mode
    jade-mode
    json-mode
    json-reformat
    ;;; markdown
    markdown-mode
    markdown-mode+
    ;;; docker
    dockerfile-mode
    ;;;php
    php-mode
    ;;: web
    web-mode
    multi-web-mode
    ;;;; html
    emmet-mode
    tidy
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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-by-moving-to-trash t)
 '(package-selected-packages
   (quote
    (wgrep-helm wgrep-ag web-mode use-package undohist undo-tree tidy tide tern-auto-complete switch-window swap-buffers sequential-command recentf-ext popwin php-mode origami multiple-cursors multi-web-mode multi-term mozc-popup monokai-theme migemo markdown-mode+ magit-tramp magit-topgit magit-svn magit-stgit magit-gitflow magit-gh-pulls magit-gerrit magit-find-file magit-filenotify magit-annex less-css-mode json-mode js2-mode jedi-direx jade-mode init-loader image+ helm-swoop helm-projectile helm-gtags helm-git-grep helm-git-files helm-flycheck helm-emmet helm-dired-recent-dirs helm-dictionary helm-descbinds helm-c-yasnippet helm-c-moccur helm-ag-r helm-ag haskell-mode gtags flycheck-pyflakes flycheck-pos-tip flycheck-color-mode-line flycheck-cask elpy dockerfile-mode coffee-mode cmake-mode cmake-ide auto-complete-clang all-ext ag)))
 '(trash-directory "~/.Trash"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
