(use-package helm
  :ensure t
  :diminish helm-mode
  :init
  (progn
    (use-package helm-config)
    (use-package helm-file)
    (use-package helm-descbinds)
    (use-package all-ext))
  (helm-mode t)
  :config
  (bind-keys* ("M-x"     . helm-M-x)
              ("C-t"     . helm-for-files)             
              ("C-x C-h" . helm-descbinds)
              ("C-x C-b" . helm-buffers-list)
              ("C-x C-f" . helm-find-files)
              ("C-x C-r" . helm-recentf)
              ("C-x C-i" . helm-imenu)
              ("C-M-y"   . helm-show-kill-ring)
              :map helm-map
              ("C-h" . delete-backward-char)
              :map helm-find-files-map
              ("C-h" . delete-backward-char)
              ("TAB" . helm-execute-persistent-action)
              :map helm-read-file-map
              ("TAB" . helm-execute-persistent-action))
  
  ;;(setq helm-migemize-command-idle-delay helm-idle-delay)
  ;;(helm-migemize-command helm-for-files)

  (setq helm-for-files-preferred-list
        '(helm-source-buffers-list
          helm-source-recentf
          ;;helm-source-files-in-current-dir
          helm-source-locate))

  ;; Emulate `kill-line' in helm minibuffer
  (setq helm-delete-minibuffer-contents-from-point t)
  )


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

;; (defun my/helm-recentf (arg)
;;   (interactive "P")
;;   (if current-prefix-arg
;;       (helm-other-buffer helm-c-recentf-directory-source "*helm recentf*")
;;     (call-interactively 'helm-recentf)))
