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
    magit-gitflow
    magit-gh-pulls
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
    ;;; js
    json-mode
    json-reformat
    ;;; markdown
    markdown-mode

    ;;; docker
    dockerfile-mode
    ;;: web
    web-mode
    ;;;; less
    less-css-mode
    ;; emacs 拡張
    image+
    migemo
    recentf-ext
    swap-buffers
    switch-window
    ;; el-get turn-off
    undohist
    wgrep
    sequential-command
    multiple-cursors
    popwin
    ;;dire 拡張
;;    direx
;;    jedi-direx
    ;; shell
    multi-term
    counsel

    ;; helm
    ;; helm
    ;; helm-ag
    ;; helm-swoop
    ;; helm-c-moccur
    ;; helm-c-yasnippet
    ;; helm-descbinds
    ;; helm-dictionary
    ;; helm-dired-recent-dirs
    ;; helm-emmet
    ;; helm-flycheck
    ;; helm-git-grep
    ;; helm-gtags
    ;; helm-projectile
    ;; wgrep-helm
    ;; all-ext
    ;; ;;
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
 '(helm-gtags-auto-update t)
 '(helm-gtags-ignore-case t)
 '(helm-gtags-path-style 'relative)
 '(js2-strict-trailing-comma-warning nil)
 '(package-selected-packages
   '(all-the-icons-ivy all-th-icons-ivy ivy-hydra ivy terraform-mode lua-mode undo-tree yaml-mode slim-mode scss-mode robe inf-ruby rbenv multi-web-mode company-go go-mode csv-mode mozc-popup mozc monokai-theme projectile all-ext wgrep-helm helm-projectile helm-ag-r helm-gtags helm-git-grep helm-git-files helm-flycheck helm-emmet helm-dired-recent-dirs helm-dictionary helm-descbinds helm-c-yasnippet helm-c-moccur helm-swoop helm-ag helm multi-term jedi-direx direx popwin multiple-cursors sequential-command wgrep undohist wgrep-ag ag switch-window swap-buffers recentf-ext migemo image+ web-mode php-mode dockerfile-mode use-package tide tern python-environment origami markdown-mode magit-topgit magit-svn magit-stgit magit-gitflow magit-gh-pulls magit-gerrit magit-find-file magit-filenotify magit-annex json-reformat json-mode js2-mode jade-mode init-loader haskell-mode flycheck-pyflakes flycheck-pos-tip flycheck-color-mode-line flycheck-cask elpy coffee-mode cmake-mode cmake-ide))
 '(trash-directory "~/.Trash"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-tooltip-scrollbar-thumb ((t (:background "#F8F8F0"))))
 '(company-tooltip-scrollbar-track ((t (:background "#75715E")))))
