;;; -*- lexical-binding: t -*-
;; Go の編集は組み込みの go-ts-mode を使い、補完・定義ジャンプ・診断は
;; eglot + gopls に統一する。gopls は別途インストールが必要。

(use-package go-ts-mode
  :ensure nil
  :init
  (add-to-list 'treesit-enabled-modes 'go-ts-mode))

(use-package eglot
  :defer t
  :init
  (add-hook 'go-ts-mode-hook 'eglot-ensure)
  (add-hook 'go-mode-hook 'eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '((go-ts-mode go-mode) . ("gopls"))))
