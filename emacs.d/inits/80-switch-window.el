(setq switch-window-threshold 3)
(setq switch-window-shortcut-style 'qwerty)
(global-set-key (kbd "C-x o") 'switch-window)


(defun switch-window-backward ()
  "Display an overlay in each window showing a unique key, then
ask user for the window where move to"
  (interactive)
  (if (<= (length (window-list)) switch-window-threshold)
      (call-interactively 'other-window-backward)
    (call-interactively 'switch-window)))
    


