(use-package tempbuf
  :diminish t
  :init
  (add-hook 'find-file-hooks 'turn-on-tempbuf-mode)
  (add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)
  )
