;;; -*- lexical-binding: t -*-
(use-package vterm
  :ensure t
  :bind ("C-c t" . vterm-other-window)
  :custom
  (vterm-max-scrollback 10000)
  :init
  ;; vterm-keymap-exceptions には :set 関数が付いていて、customize 経由で
  ;; 値をセットすると vterm-mode-map が既に構築済みの場合に除外処理を
  ;; 再実行してしまい、C-c C-t 等のサブバインドが復元されず消える
  ;; (use-package の :custom は customize-set-variable を使うため発火する)。
  ;; setq なら :set フックを経由しないので、この事故を避けられる。
  (setq vterm-keymap-exceptions '("<f1>" "<f2>" "C-c" "C-x" "C-u" "C-g" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y")))
