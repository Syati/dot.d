(use-package ivy
  :ensure t
  :init
  (progn (use-package ivy-hydra :ensure  t)
         (use-package counsel :ensure  t)
         (use-package all-the-icons :if (display-graphic-p))
         (use-package all-the-icons-ivy :ensure t
             :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))
         )

  (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-wrap t)
  (ivy-count-format "(%d/%d) ")
  (ivy-height 30)
  :config
  (bind-keys*
   ("C-t" . ivy-switch-buffer)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)
   ("M-x" . counsel-M-x)
   ("C-s" . swiper-isearch)
   ("C-c C-r" . ivy-resume)
   :map ivy-minibuffer-map
   ("C-z" . grugrut/ivy-partial)
   :map counsel-find-file-map
   ("C-l" . counsel-up-directory))
  )
