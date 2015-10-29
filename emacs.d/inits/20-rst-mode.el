;; rst.elを読み込み
(autoload 'rst "rst" nil t)
(autoload 'auto-complete-rst "auto-complete-rst" nil t)

(auto-complete-rst-init)
;; *.rst, *.restファイルをrst-modeでOpen
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)
                ) auto-mode-alist))

(setq frame-background-mode 'dark)
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))

