;;; -*- lexical-binding: t -*-
;; ruby バージョン管理は mise が PATH を通す前提。exec-path-from-shell が
;; ログインシェルの PATH を引き継ぐので、Emacs 側でバージョンマネージャ
;; 固有の設定は不要。
;;
;; 補完・定義ジャンプ・診断は eglot (組み込み) + ruby-lsp に統一。
;; `gem install ruby-lsp` (または Gemfile に追加) が別途必要。

(use-package eglot
  :defer t
  :init
  ;; treesit-auto が有効な環境では ruby-ts-mode に切り替わるため両方に掛ける
  (add-hook 'ruby-mode-hook 'eglot-ensure)
  (add-hook 'ruby-ts-mode-hook 'eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '((ruby-mode ruby-ts-mode) . ("ruby-lsp"))))
