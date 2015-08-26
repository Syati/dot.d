;; rst.elを読み込み
(require 'rst)
(require 'auto-complete-rst)

(auto-complete-rst-init)
;; *.rst, *.restファイルをrst-modeでOpen
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)
                ) auto-mode-alist))

(setq frame-background-mode 'dark)
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))

