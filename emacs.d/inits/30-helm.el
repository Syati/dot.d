
(require 'helm-config)
(helm-mode 1)
;; ;;(require 'helm-migemo)
(require 'helm-descbinds)
(helm-descbinds-mode)

(require 'all-ext)


;;(setq helm-migemize-command-idle-delay helm-idle-delay)
;;(helm-migemize-command helm-for-files)

(define-key global-map (kbd "C-M-x")   'helm-M-x)
(define-key global-map (kbd "C-t")     'helm-for-files)
(define-key global-map (kbd "C-x C-h") 'helm-descbinds)
(define-key global-map (kbd "C-x C-b") 'helm-buffers-list)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'my/helm-recentf)
(define-key global-map (kbd "C-x C-i") 'helm-imenu)
(define-key global-map (kbd "C-M-y")   'helm-show-kill-ring)

(define-key helm-map (kbd "C-h")            'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "TAB")  'helm-execute-persistent-action)

(add-hook 'helm-gtags-mode-hook
          '(lambda ()
              (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
              (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
              (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
              (local-set-key (kbd "M-y") 'helm-gtags-pop-stack)
              ))

(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
        helm-source-recentf
        ;;helm-source-files-in-current-dir
        helm-source-locate))

;; Emulate `kill-line' in helm minibuffer
(setq helm-delete-minibuffer-contents-from-point t)
(defadvice helm-delete-minibuffer-contents (before helm-emulate-kill-line activate)
  "Emulate `kill-line' in helm minibuffer"
  (kill-new (buffer-substring (point) (field-end))))

(defadvice helm-ff-transform-fname-for-completion (around my-transform activate)
  "Transform the pattern to reflect my intention"
  (let* ((pattern (ad-get-arg 0))
         (input-pattern (file-name-nondirectory pattern))
         (dirname (file-name-directory pattern)))
    (setq input-pattern (replace-regexp-in-string "\\." "\\\\." input-pattern))
    (setq ad-return-value
          (concat dirname
                  (if (string-match "^\\^" input-pattern)
                      ;; '^' is a pattern for basename
                      ;; and not required because the directory name is prepended
                      (substring input-pattern 1)
                    (concat ".*" input-pattern))))))


;; helm recentf only directories
;;(defvar helm-c-recentf-directory-source
;;  '((name . "Recentf Directry")
;;    (candidates . (lambda ()
;;                    (loop for file in recentf-list
;;                          when (file-directory-p file)
;;                          collect file)))
;;    (type . file)))

(defun my/helm-recentf (arg)
  (interactive "P")
  (if current-prefix-arg
      (helm-other-buffer helm-c-recentf-directory-source "*helm recentf*")
    (call-interactively 'helm-recentf)))
