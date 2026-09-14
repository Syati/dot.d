;;; -*- lexical-binding: t -*-
(use-package vterm
  :ensure t
  :bind ("C-c t" . vterm-other-window)
  :custom
  (vterm-max-scrollback 10000)
  (vterm-keymap-exceptions '("<f1>" "<f2>" "C-c" "C-x" "C-u" "C-g" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y"))
  )
