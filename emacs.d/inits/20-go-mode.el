(use-package go-mode
  :ensure t
  :defer t
  :mode (("\\.go$" . go-mode))
  :init
  (add-hook 'go-mode-hook 'flycheck-mode)
  (add-hook 'go-mode-hook (lambda()
       (add-hook 'before-save-hook' 'gofmt-before-save)
       (local-set-key (kbd "M-t") 'godef-jump)
       (set (make-local-variable 'company-backends) '(company-go))
       (setq indent-tabs-mode nil)    ; タブを利用
       (setq c-basic-offset 4)    ; tabサイズを4にする
       (setq tab-width 4)))

  (add-hook 'go-mode-hook (lambda()
      (company-mode)
      (setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
      (setq company-idle-delay 0) ; 遅延なしにすぐ表示
      (setq company-minimum-prefix-length 3) ; デフォルトは4
      (setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
      (setq completion-ignore-case t)
      (setq company-dabbrev-downcase nil)))
  )

(use-package company-go
  :ensure t
  :defer t
  )
