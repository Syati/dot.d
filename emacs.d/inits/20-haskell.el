;; haskell
(use-package haskell-mode
  :commands haskell-cabal
  :mode (("\\.hs$" . haskell-mode)
         ("\\.lhs$" . literate-haskell-mode)
         ("\\.cabal\\'" . haskell-cabal-mode))
  )
