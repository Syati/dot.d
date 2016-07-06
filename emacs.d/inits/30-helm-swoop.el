(use-package helm-swoop
  :bind (("M-i"     . helm-swoop)
         ("M-I"     . helm-swoop-back-to-last-point)
         ("C-c M-i" . helm-multi-swoop)
         ("C-x M-i" . helm-multi-swoop-all))
  :config
  (bind-keys :map helm-swoop-map
             ;; helm-swoop実行中にhelm-multi-swoop-allに移行             
             ("M-i" . helm-multi-swoop-all-from-helm-swoop))
  (bind-keys :map isearch-mode-map
             ("M-i" . helm-swoop-from-isearch))
  ;; Save buffer when helm-multi-swoop-edit complete
  (setq helm-multi-swoop-edit-save t)
  
  ;; 値がtの場合はウィンドウ内に分割、nilなら別のウィンドウを使用
  (setq helm-swoop-split-with-multiple-windows nil)
  
  ;; ウィンドウ分割方向 'split-window-vertically or 'split-window-horizontally
  (setq helm-swoop-split-direction 'split-window-vertically)
  
  ;; nilなら一覧のテキストカラーを失う代わりに、起動スピードをほんの少し上げる
  (setq helm-swoop-speed-or-color t))
