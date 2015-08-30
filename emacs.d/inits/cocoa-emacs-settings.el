;; override local
(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)


(let ((my-emacs-path (list
         (expand-file-name "~/node_modules/.bin")
         (expand-file-name "~/.rbenv/shims")
         "/usr/local/opt/coreutils/libexec/gnubin"
         "/usr/local/bin"
         "/usr/bin"
         "/usr/sbin"
         "/sbin"
         "/bin"
         )))
    (setq exec-path (append my-emacs-path exec-path))
    (setenv "PATH" (mapconcat 'identity exec-path ":")))


(setq dired-listing-switches "-AlGh")
(setq ls-lisp-dirs-first t)
;; resolve Listing directory failed but access-file worked
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)

(setq multi-term-program "/usr/local/bin/zsh")
;;(setenv "TERMINFO" "~/.terminfo")


(if (setq browse-url-browser-function
        'browse-url-generic browse-url-generic-program
        "open"))
