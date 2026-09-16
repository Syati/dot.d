;;; -*- lexical-binding: t -*-
(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode))

;; GitHub 風のライブプレビュー。`pip install grip` (または pipx) が別途必要。
(use-package grip-mode
  :ensure t
  :hook (markdown-mode . grip-mode))

;; テーブルの列位置を日本語(全角文字)混在でも揃える
(use-package valign
  :ensure t
  :hook (markdown-mode . valign-mode))
