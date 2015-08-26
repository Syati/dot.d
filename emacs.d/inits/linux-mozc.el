(require 'mozc)
(require 'mozc-popup)
;; or (load-file "/path/to/mozc.el")
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'popup)

(define-minor-mode overriding-minor-mode
  "強制的にC-tを割り当てる"             ;説明文字列
  t                                     ;デフォルトで有効にする
  ""                                    ;モードラインに表示しない
  `((,(kbd "C-/") . mozc-mode)))








