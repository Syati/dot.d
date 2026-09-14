;;; -*- lexical-binding: t -*-
;; ウィンドウ配置の undo/redo (組み込み)
(winner-mode 1)
(global-set-key (kbd "C-c <left>") 'winner-undo)
(global-set-key (kbd "C-c <right>") 'winner-redo)

;; ウィンドウのリサイズ。C-c w <矢印> の後は矢印キーだけで連続リサイズできる
(repeat-mode 1)
(defvar-keymap my-window-resize-repeat-map
  :repeat t
  "<left>"  #'shrink-window-horizontally
  "<right>" #'enlarge-window-horizontally
  "<up>"    #'enlarge-window
  "<down>"  #'shrink-window)
(global-set-key (kbd "C-c w <left>")  #'shrink-window-horizontally)
(global-set-key (kbd "C-c w <right>") #'enlarge-window-horizontally)
(global-set-key (kbd "C-c w <up>")    #'enlarge-window)
(global-set-key (kbd "C-c w <down>")  #'shrink-window)

;; 左から順に指定した幅(%)の横並びウィンドウに一発で組み直す
(defun my-window-layout-columns (percents)
  "Lay out the frame as side-by-side windows sized by PERCENTS (must sum to 100)."
  (unless (= (apply #'+ percents) 100)
    (user-error "Percentages must sum to 100, got %s" percents))
  (delete-other-windows)
  (let ((total (window-total-width))
        (win (selected-window)))
    (dolist (pct (butlast percents))
      (setq win (split-window win (round (* total (/ pct 100.0))) 'right)))))

(defun my-window-layout-columns-prompt (spec)
  "Prompt for space-separated column width percentages, e.g. \"20 20 60\"."
  (interactive "sColumn widths percent (e.g. 20 20 60): ")
  (my-window-layout-columns (mapcar #'string-to-number (split-string spec))))

(global-set-key (kbd "C-c w =") #'my-window-layout-columns-prompt)
