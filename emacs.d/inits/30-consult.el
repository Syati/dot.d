;;; -*- lexical-binding: t -*-
(use-package consult
  :ensure t
  :bind*
  (("C-t"   . consult-buffer)
   ("C-s"   . consult-line)
   ("C-x C-r" . consult-recent-file)
   ("M-s r" . consult-ripgrep))
  :config
  ;; 候補を選んだだけでは自動プレビューせず、C-o を押したときだけ表示する
  (consult-customize consult-buffer consult-recent-file :preview-key "C-o")

  ;; consult-buffer に tab-bar のタブ (tabspaces のワークスペースも同じもの)
  ;; を候補として追加する。tab-bar-switch-to-tab は既存なら切り替え、
  ;; 無ければ新規作成してくれるので選択・新規作成の両方をこれ1つで賄える
  (defvar consult--source-tab-bar
    `(:name "Tab"
      :category tab
      :face consult-buffer
      ;; vertico-sort-function (履歴/文字数/アルファベット順) で候補が
      ;; 並べ替えられ先頭に来なくなるのを防ぎ、渡した順序をそのまま使わせる
      :sort nil
      :action ,#'tab-bar-switch-to-tab
      :new ,#'tab-bar-switch-to-tab
      :items ,(lambda ()
                (mapcar (lambda (tab) (alist-get 'name tab))
                        (funcall tab-bar-tabs-function))))
    "Consult source for tab-bar tabs.")
  (add-to-list 'consult-buffer-sources 'consult--source-tab-bar))
