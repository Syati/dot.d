(defun swap-buffers-keep-focus ()
  (interactive)
  (swap-buffers t))
;;; 無設定で使えるが、swap-screenに倣ってf2/S-f2に割り当てる
(global-set-key [f2] 'swap-buffers-keep-focus)
(global-set-key [S-f2] 'swap-buffers)

