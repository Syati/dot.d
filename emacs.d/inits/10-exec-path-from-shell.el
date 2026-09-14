;;; -*- lexical-binding: t -*-
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize)
  ;; mise は `activate' フックで PATH を通すため、exec-path-from-shell が
  ;; 起動する非対話シェルではフックが発火せず mise 管理のツールが見つからない。
  ;; `mise bin-paths' で解決済みの bin ディレクトリを直接足す。
  (when (executable-find "mise")
    (dolist (dir (split-string (shell-command-to-string "mise bin-paths") "\n" t))
      (add-to-list 'exec-path dir)
      (setenv "PATH" (concat dir path-separator (getenv "PATH"))))))
