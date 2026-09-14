;;; -*- lexical-binding: t -*-
;; override local
(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)

;; PATH は exec-path-from-shell がログインシェル(mise 含む)から引き継ぐ

(setq dired-listing-switches "-AlGhg")
;; resolve Listing directory failed but access-file worked
(require 'ls-lisp)
(setq ls-lisp-dirs-first t)
(setq ls-lisp-use-insert-directory-program nil)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "open")
