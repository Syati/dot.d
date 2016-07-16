;; haskell
(use-package haskell-mode
  :ensure t
  :mode (("\\.hs$" . haskell-mode)
         ("\\.lhs$" . literate-haskell-mode)
         ("\\.cabal\\'" . haskell-cabal-mode))
  )
