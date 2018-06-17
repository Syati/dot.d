(use-package company
  :defer t
  :config
  (setq company-auto-expand t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-selection-wrap-around t)
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)

  (custom-set-faces
    '(company-scrollbar-bg ((t (:background "#75715E"))))
    '(company-scrollbar-fg ((t (:background "#F8F8F0")))))
  :bind (("C-M-i" . company-complete)
         :map company-active-map
         ("\C-g" . company-abort)
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)
         ([return] . company-complete-selection)
         ("RET" . company-complete-selection)
         ([tab] . company-complete-common)
         ("TAB" . company-complete-common)
         ("<f1>" . company-show-doc-buffer)
         ("\C-w" . company-show-location)
         ("\C-s" . company-search-candidates)
         ("\C-h" . nil)
         )
  :init
  (global-company-mode)
  )
