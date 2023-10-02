(use-package org
  :config
  (setq org-src-fontify-natively t)
  ;; org-modeでの強調表示を可能にする
  (add-hook 'org-mode-hook 'turn-on-font-lock)
  ;; org-default-notes-fileのディレクトリ
  (setq org-directory "~/org")
  ;; org-default-notes-fileのファイル名
  (setq org-agenda-files (list org-directory))

  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
           "** TODO %?\n %T\n %a\n %i\n")
          ("j" "Journal" entry (file+datetree "~/org/journal.org" "Journals")
           "** %?\n %U\n %i\n %a")
          ("n" "Note" entry (file+headline "~/org/notes.org" "Notes")
           "** %? %U %i :NOTE:\n")
          ))

  (setq org-agenda-custom-commands
        '(
          ("n" "Notes" tags "NOTE")
          ))
  )
