(autoload 'php-mode "php-mode")
(setq php-warned-bad-indent t)
(setq auto-mode-alist
      (cons '("\\.php\\'" . php-mode) auto-mode-alist))

(setq php-search-url "http://www.php.net/ja/")
(setq php-manual-url "http://www.php.net/manual/ja/")

(setq php-mode-force-pear t)

;;; php-mode-hook
;; (add-hook 'php-mode-hook
;;           (lambda ()
;;             (require 'php-completion)
             
;;             (define-key php-mode-map [tab] 'phpcmp-complete)
;;             (php-completion-mode t)
;;             (hs-minor-mode t)
;;             (make-local-variable 'ac-sources)
;;             (setq ac-sources '(
;;                                ac-source-words-in-same-mode-buffers
;;                                ac-source-php-completion
;;                                ac-source-filename
;;                                ))))
