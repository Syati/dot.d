;;Tag select function ( gnu global )
(autoload 'gtags "gtags" nil t)
(setq gtags-path-style 'relative)
(setq gtags-read-only t)
(setq gtags-pop-delete t)

(add-hook 'java-mode-hook (lambda () (gtags-mode 1)))
(add-hook 'c-mode-hook (lambda () (gtags-mode 1)))
(add-hook 'c++-mode-hook (lambda () (gtags-mode 1))) 
(add-hook 'php-mode-hook (lambda () (gtags-mode 1))) 

