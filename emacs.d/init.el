;================================;
; use common lisp                ;
;================================;

(require 'cl)
(require 'cl-macs)

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

;; package archives
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)


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
    flycheck
    flycheck-cask
    flycheck-color-mode-line
    flycheck-pos-tip
    flycheck-pyflakes
    flymake-cursor
    ;; yanippet
    yasnippet
    angular-snippets
    react-snippets
    dropdown-list
    ;; 開発モード
    ;;; rest client
    restclient
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
    elscreen
    elscreen-persist
    swap-buffers    
    switch-window
    ;; el-get turn-off
    ag
    wgrep-ag
    redo+
    undo-tree
    undohist
    xml-rpc
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
    ;;
    concurrent
    ctable
    dash
    deferred
    epc
    epl
    f
    find-file-in-project
    fringe-helper
    fuzzy
    gh
    highlight-indentation
    idomenu
    iedit
    logito
    nose
    pcache
    pkg-info
    popup
    s
    sws-mode
    ))

(let ((not-installed (loop for x in installing-package-list
                            when (not (package-installed-p x))
                            collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
        (package-install pkg))))

(require 'init-loader)
(setq init-loader-show-log-after-init nil)
(init-loader-load "~/.emacs.d/inits")


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
