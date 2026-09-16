;;; -*- lexical-binding: t -*-
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

(setq package-archives '(("melpa"  . "https://melpa.org/packages/")
                          ("gnu"    . "https://elpa.gnu.org/packages/")
                          ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; init-loader / use-package themselves must be present before
;; init-loader-load can hand installation off to each use-package block.
(dolist (pkg '(init-loader use-package))
  (unless (package-installed-p pkg)
    (package-install pkg)))


;================================;
; initial use-package            ;
;================================;

(require 'use-package)

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
 '(package-selected-packages
   '(ace-window agent-shell consult corfu corfu-terminal dockerfile-mode
                exec-path-from-shell init-loader magit
                marginalia markdown-mode migemo multiple-cursors
                nerd-icons nerd-icons-completion orderless
                sequential-command tabspaces treesit-auto undo-tree
                use-package use-package-ensure-system-package valign
                vertico vterm wgrep))
 '(package-vc-selected-packages
   '((use-package-ensure-system-package :vc-backend Git :url
                                        "https://github.com/waymondo/use-package-ensure-system-package"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
