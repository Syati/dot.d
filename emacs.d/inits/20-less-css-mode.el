(autoload 'less-css-mode "less-css-mode.el" "LESS mode" t)
(add-hook 'less-css-mode-hook
          '(lambda()
             (setq css-indent-offset 2)
             ))
