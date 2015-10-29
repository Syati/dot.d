(autoload 'origami "origami" nil t)

(add-to-list 'origami-parser-alist '(coffee-mode . origami-indent-parser))


(defun origami-cycle (recursive)
  "origamiの機能をorg風にまとめる"
  (interactive "P")
  (call-interactively
   (if recursive 'origami-toggle-all-nodes 'origami-toggle-node)))


(define-key origami-mode-map (kbd "C-;") 'origami-cycle)

