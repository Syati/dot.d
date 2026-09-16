;;; -*- lexical-binding: t -*-
(use-package magit
  :ensure t
  :defer t
  :init
  (bind-keys* ("C-x g" . magit-status)
              ("C-x M-g" . magit-dispatch))
  ;; project-vc-dir (組み込みvc-dir) より magit-status の方が使いやすいので上書き
  (define-key project-prefix-map "v" #'magit-status)
  :config
  (setq magit-visit-ref-behavior '(checkout-any focus-on-ref))
  )
