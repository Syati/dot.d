(autoload 'flycheck "flycheck" nil t)
(add-hook 'js2-mode-hook 'flycheck-mode)
(add-hook 'php-mode-hook 'flycheck-mode)

(custom-set-variables
 '(flycheck-jshintrc "~/.jshintrc"))

(setq flycheck-check-syntax-automatically '(save
                                            mode-enabled))

















