;;; -*- lexical-binding: t -*-
;; brew install cmigemo で導入。未導入の環境では何もしない。
(use-package migemo
  :ensure t
  :if (executable-find "cmigemo")
  :init
  (setq migemo-command (executable-find "cmigemo"))
  (setq migemo-dictionary
        (car (seq-filter #'file-exists-p
                          '("/opt/homebrew/share/migemo/utf-8/migemo-dict"
                            "/usr/local/share/migemo/utf-8/migemo-dict"))))
  (setq search-whitespace-regexp nil)
  :config
  (migemo-init))
