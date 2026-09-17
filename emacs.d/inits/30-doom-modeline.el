;;; -*- lexical-binding: t -*-
;; アイコンは 30-nerd-icons.el でセットアップ済みの nerd-icons を使う。
;; git ブランチ・flymake のエラー数・行/列・major-mode は残し、
;; マイナーモード一覧・エンコーディング・インデント種別・ワークスペース名
;; (tab-bar/tabspaces と表示が重複する) は間引く。

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-icon t
        doom-modeline-minor-modes nil
        doom-modeline-buffer-encoding nil
        doom-modeline-indent-info nil
        doom-modeline-workspace-name nil)
  :config
  (doom-modeline-mode 1))
