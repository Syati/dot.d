(require 'ag)
(setq ag-highlight-search t)  ; 検索キーワードをハイライト
;;(setq ag-reuse-buffers t)     ; 検索用バッファを使い回す (検索ごとに新バッファを作らない)

(require 'wgrep-ag)
(autoload 'wgrep-ag-setup "wgrep-ag")
(add-hook 'ag-mode-hook 'wgrep-ag-setup)
(define-key ag-mode-map (kbd "r") 'wgrep-change-to-wgrep-mode)
