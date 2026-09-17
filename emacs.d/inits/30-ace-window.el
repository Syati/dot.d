;;; -*- lexical-binding: t -*-
(use-package ace-window
  :ensure t
  :demand t
  :bind (("C-x o" . ace-window)
         ("M-o"   . aw-flip-window))
  :config
  ;; aw-keys のデフォルトは 1..9 の数字。それに合わせて s-<数字> で
  ;; 選択プロンプト無しのワンショットジャンプにする (winum の M-<数字>
  ;; 相当)。番号は aw-window-list の並び順 (画面左上→右下) に対応する。
  (defun my/aw-select-window-by-number (n)
    "Select the Nth (1-indexed) window from `aw-window-list'."
    (let ((win (nth (1- n) (aw-window-list))))
      (if win (select-window win) (message "No window %d" n))))
  (dotimes (i 9)
    (let ((n (1+ i)))
      (global-set-key (kbd (format "s-%d" n))
                       (lambda () (interactive) (my/aw-select-window-by-number n)))))
  ;; モードラインへの常時番号表示。doom-modeline は ace-window-display-mode
  ;; 自身の mode-line-format 書き込みは無効化する (doom-modeline-segments.el
  ;; の doom-modeline-override-window-number) が、doom-modeline 側に
  ;; ace-window 連携済みの window-number セグメントが最初から入っており、
  ;; ace-window-display-mode が更新する window-parameter (ace-window-path)
  ;; を直接読んで表示してくれる。
  (ace-window-display-mode 1))
