 (use-package view
    :bind
    ("C-c C-v" . view-mode)
    :config
    (bind-keys
     :map view-mode-map
     ("h"     . backward-char)
     ("j"     . next-line)
     ("k"     . previous-line)
     ("l"     . forward-char)
     ("w"     . forward-word)
     ("b"     . backward-word)
     ("C-u"   . scroll-down)
     ("SPC"   . scroll-up)
     ("C-d"   . scroll-up)
     ("0"     . beginning-of-line)
     ("$"     . end-of-line)
     ("g"     . beginning-of-buffer)
     ("G"     . end-of-buffer)))
