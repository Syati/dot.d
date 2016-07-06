(use-package php-mode
  :mode (("\\.php\\'"  . php-mode))
  :config  
  (setq php-mode-coding-style (quote psr2))
  )

(provide '20-php)

;;(setq php-mode-force-pear t)

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
