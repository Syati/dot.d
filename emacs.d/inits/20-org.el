(require 'org-install)

(setq org-src-fontify-natively t)
;; org-modeでの強調表示を可能にする
(add-hook 'org-mode-hook 'turn-on-font-lock)
;; org-default-notes-fileのディレクトリ
(setq org-directory "~/org/")
;; org-default-notes-fileのファイル名
(setq org-default-notes-file "notes.org")

