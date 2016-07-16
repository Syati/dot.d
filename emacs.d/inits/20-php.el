(use-package php-mode
  :ensure t
  :mode (("\\.php\\'"  . php-mode))
  :config
  (use-package flycheck)
  (setq php-mode-coding-style (quote psr2))
  (add-hook 'php-mode-hook
            (lambda ()
              (setq flycheck-phpcs-standard "PSR2")))
  )


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
