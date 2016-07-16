(use-package origami
  :ensure t
  :init
  (global-origami-mode)
  (bind-keys* ("C-c C-o ="     . origami-open-node)
              ("C-c C-o +"     . origami-open-all-nodes)
              ("C-c C-o -"     . origami-close-node)
              ("C-c C-o \_"    . origami-close-all-nodes)
              ("C-c C-o C-r"   . origami-recursively-toggle-node))
  )


