;;; eでwgrepモードにする
(setf wgrep-enable-key "e")
;;; wgrep終了時にバッファを保存
(setq wgrep-auto-save-buffer t)
;;; read-only bufferにも変更を適用する
(setq wgrep-change-readonly-file t)
