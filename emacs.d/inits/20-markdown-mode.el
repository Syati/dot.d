;;; -*- lexical-binding: t -*-
(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode))

;; テーブルの列位置を日本語(全角文字)混在でも揃える
(use-package valign
  :ensure t
  :hook (markdown-mode . valign-mode))
