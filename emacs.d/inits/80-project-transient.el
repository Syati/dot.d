;;; -*- lexical-binding: t -*-
;; C-x p は2打鍵ともCtrlを一度離す必要があって面倒なので、よく使う
;; project.el 系コマンドをまとめて transient (magit の依存で既に導入済み)
;; メニューにする。95-keybind.el で左Cmdを Super にしているので、
;; Ctrl+Option+Cmd+p (= C-M-s-p) で直接開ける。

(require 'transient)

(transient-define-prefix my/project-transient ()
  "Project commands."
  [["Find"
    ("f" "Find file"      project-find-file)
    ("d" "Find dir"        project-find-dir)
    ("b" "Switch buffer"  project-switch-to-buffer)
    ("g" "Ripgrep"        consult-ripgrep)]
   ["Browse"
    ("e" "Sidebar"        dirvish-side)
    ("v" "Magit status"   magit-status)]
   ["Workspace"
    ("p" "Switch project" project-switch-project)
    ("k" "Kill buffers"   project-kill-buffers)]])

(global-set-key (kbd "s-p") #'my/project-transient)
