;;; -*- lexical-binding: t -*-
;; completion-at-point 用のポップアップ補完。eglot の capf や agent-shell の
;; @ 補完など、completion-at-point-functions を使うものすべてに効く。
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t))

;; デフォルトの emacs コマンドは -nw (ターミナル)。Emacs 30 以前はターミナルで
;; ポップアップを描画するのに corfu-terminal が必要だったが、Emacs 31 は
;; corfu 本体がネイティブに対応したため不要 (読み込むと警告が出る)。
(use-package corfu-terminal
  :ensure t
  :unless (or (display-graphic-p) (>= emacs-major-version 31))
  :config
  (corfu-terminal-mode 1))
