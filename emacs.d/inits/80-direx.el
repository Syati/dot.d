(require 'direx)
(setq direx:leaf-icon "  "
      direx:open-icon "▾ "
      direx:closed-icon "▸ ")

(defun direx:jump-to-project-directory ()
  (interactive)
  (let ((result (ignore-errors
                  (direx-project:jump-to-project-root-other-window)
                  t)))
    (unless result
      (direx:jump-to-directory-other-window))))

