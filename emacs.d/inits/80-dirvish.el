;;; -*- lexical-binding: t -*-
;; dirvish のアイコン描画や属性表示は dirvish-override-dired-mode が仕込む
;; advice (dired--find-file 等) 経由でしか発動しないため、dired 全体で
;; override-dired-mode を有効化する。dirvish-override-dired-mode は
;; ;;;###autoload 付きなので :init で呼ぶだけで package 本体が require
;; される。80-dired.el の find-alternate-file 化やバッファ自動 kill は
;; 別関数への advice/keymap なので競合しない。

(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  (setq dirvish-side-width 40)
  ;; nerd-icons (30-nerd-icons.el で導入済み) でファイルアイコンを表示。
  ;; dirvish-side-attributes は dirvish-attributes の読み込み時点の値を
  ;; 引き継ぐだけなので、side 用にも明示しておく。
  (setq dirvish-attributes '(nerd-icons)
        dirvish-side-attributes '(nerd-icons))
  :bind (:map project-prefix-map
         ("e" . dirvish-side))
  :config
  ;; dirvish-hide-details (デフォルト t) はフルフレームレイアウト
  ;; (dirvish--build-layout) 経由でしか dired-hide-details-mode を
  ;; 切り替えない実装で、side/default セッションでは発火しないため、
  ;; dired-mode-hook で直接有効化する。file-size 属性の overlay 表示も
  ;; dired-hide-details-mode が on であることが前提になっている。
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  ;; 現在のバッファに合わせてサイドバーのカーソル位置・プロジェクトを追従させる
  (dirvish-side-follow-mode))
