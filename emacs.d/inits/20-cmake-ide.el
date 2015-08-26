(require 'cmake-mode)
;;(cmake-ide-setup)

(setq auto-mode-alist
	  (append
	   '(("CMakeLists\\.txt\\'" . cmake-mode))
	   '(("\\.cmake\\'" . cmake-mode))
	   auto-mode-alist))

(add-hook 'cmake-mode-hook
          '(lambda ()
             (auto-complete-mode t)
             ))
