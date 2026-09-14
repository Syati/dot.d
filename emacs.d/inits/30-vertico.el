;;; -*- lexical-binding: t -*-
;; find-file, M-x, switch-buffer など標準の completing-read を使うコマンドは
;; 無設定のまま自動的に vertico の UI になる。

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-count 30))

(use-package vertico-directory
  :after vertico
  :bind (:map vertico-map
              ("C-l" . vertico-directory-up)
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)))

(use-package vertico-repeat
  :after vertico
  ;; C-c C-r は 95-keybind.el で revert-buffer に割り当て済みのため C-c v を使う
  :bind (("C-c v" . vertico-repeat))
  :init
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save))
