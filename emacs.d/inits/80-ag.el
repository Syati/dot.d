(use-package ag
  :ensure t
  :defer t
  :init
  (use-package wgrep-ag
    :ensure t
    )
  :config
  (bind-keys :map ag-mode-map
             ("r" . wgrep-change-to-wgrep-mode))
  (setq ag-highlight-search t)  ; 検索キーワードをハイライト
  ;;(setq ag-reuse-buffers t)     ; 検索用バッファを使い回す (検索ごとに新バッファを作らない)
  )
