;;; -*- lexical-binding: t -*-
;; 30分 (デフォルト) 操作のないバッファを自動で閉じる。可視バッファ・
;; プロセス付きバッファ・*scratch*/*Messages* 等の special バッファは
;; デフォルトで保護対象。
;;
;; tabspaces はタブごとの buffer-list/buried-buffer-list でワークスペースの
;; バッファを管理しているが、buffer-terminator の可視判定はウィンドウに
;; 表示中かどうかしか見ない (tab-bar-get-buffer-tab は各タブの
;; window-state 上のバッファのみを見て、埋もれた buffer-list までは見ない)。
;; そのため file 訪問バッファを一律で保護し、閉じるのは file 以外の
;; 一時バッファ (*Help* や grep 結果等) に限定する。
(use-package buffer-terminator
  :ensure t
  :config
  (setq buffer-terminator-rules-alist
        (append buffer-terminator-rules-alist
                '((keep-buffer-property . file))))
  (buffer-terminator-mode 1))
