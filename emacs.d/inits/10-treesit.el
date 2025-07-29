(use-package treesit
  :config
  (setenv "TREE_SITTER_LIBDIR" "~/emacs.d/tree-sitter")
  (setq treesit-font-lock-level 4))

(use-package treesit-auto
  :ensure t
  :init
    (setq treesit-language-source-alist
        '((typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master"
                         "typescript/src"))
          (tsx        . ("https://github.com/tree-sitter/tree-sitter-typescript" "master"
                         "tsx/src"))))
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
