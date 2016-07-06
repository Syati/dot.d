;; markdown-Mode
(use-package markdown-mode
  :init
  :bind (:map markdown-mode-map
              ("<tab>" . nil))
  :mode (("\\.mdwn$" . markdown-mode)
         ("\\.md$"   . markdown-mode)
         ("\\.mdt$"  . markdown-mode))
  )
