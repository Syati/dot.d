;; override local
(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)


(let ((my-emacs-path (list
         "/opt/local/bin"
         "/sw/bin"
         "/usr/local/bin"
         "/usr/bin"
         "/usr/sbin/"
         "/bin"
         "/Applications/Emacs.app/Contents/MacOS/bin"
         )))
    (setq exec-path my-emacs-path)
    (setenv "PATH" (mapconcat 'identity my-emacs-path ":")))


(setq dired-listing-switches "-AlGh")
(setq ls-lisp-dirs-first t)
;; resolve Listing directory failed but access-file worked 
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)

(setq multi-term-program "/usr/local/bin/zsh")
(setenv "TERMINFO" "~/.terminfo")


(if (setq browse-url-browser-function
        'browse-url-generic browse-url-generic-program
        "open"))
