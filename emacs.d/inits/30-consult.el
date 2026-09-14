;;; -*- lexical-binding: t -*-
(use-package consult
  :ensure t
  :bind*
  (("C-t"   . consult-buffer)
   ("C-s"   . consult-line)
   ("C-x C-r" . consult-recent-file)))
