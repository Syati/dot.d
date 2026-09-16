;;; -*- lexical-binding: t -*-
(use-package consult
  :ensure t
  :bind*
  (("C-t"   . consult-buffer)
   ("C-s"   . consult-line)
   ("C-x C-r" . consult-recent-file))
  :config
  ;; 候補を選んだだけでは自動プレビューせず、C-o を押したときだけ表示する
  (consult-customize consult-buffer consult-recent-file :preview-key "C-o"))
