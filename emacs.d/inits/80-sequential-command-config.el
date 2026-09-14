;;; -*- lexical-binding: t -*-
(use-package sequential-command-config
  :ensure sequential-command
  :bind (("C-a"     . seq-home)
         ("C-e"     . seq-end)
         ("M-u"     . seq-upcase-backward-word)
         ("M-c"     . seq-capitalize-backward-word)
         ("M-l"     . seq-downcase-backward-word))
  )


