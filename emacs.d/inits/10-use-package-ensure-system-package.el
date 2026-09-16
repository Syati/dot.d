;;; -*- lexical-binding: t -*-
;; use-package-ensure-system-package は MELPA から配信されていないため
;; package-vc-install で GitHub から直接入れる。:ensure-system-package を
;; 使う他の init ファイル (markdown-mode, agent-shell 等) より先に
;; 読み込まれるよう、番号の早いここでまとめてセットアップする。
(use-package system-packages
  :ensure t)
(unless (package-installed-p 'use-package-ensure-system-package)
  (package-vc-install "https://github.com/waymondo/use-package-ensure-system-package"))
(require 'use-package-ensure-system-package)
