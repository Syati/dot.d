;; override local
(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)


(let ((my-emacs-path (list
         (expand-file-name "~/node_modules/.bin")
         (expand-file-name "~/.rbenv/shims")
         "/opt/homebrew/bin/"
         "/usr/local/bin"
         "/usr/bin"
         "/usr/sbin"
         "/sbin"
         "/bin"
         )))
    (setq exec-path (append my-emacs-path exec-path))
    (setenv "PATH" (mapconcat 'identity exec-path ":")))


(setq dired-listing-switches "-AlGhg")
;; resolve Listing directory failed but access-file worked
(require 'ls-lisp)
(setq ls-lisp-dirs-first t)
(setq ls-lisp-use-insert-directory-program nil)

(setq multi-term-program "/usr/local/bin/zsh")
;;(setenv "TERMINFO" "~/.terminfo")


(setq browse-url-browser-function
      'browse-url-generic browse-url-generic-program
      "open")

(defun copy-from-osx ()
 (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
 (let ((process-connection-type nil))
     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
       (process-send-string proc text)
       (process-send-eof proc))))

;;(setq interprogram-cut-function 'paste-to-osx)
;;(setq interprogram-paste-function 'copy-from-osx)
