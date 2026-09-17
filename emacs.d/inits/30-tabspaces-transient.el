;;; -*- lexical-binding: t -*-
;; C-x t も project 同様2打鍵ともCtrlを離す必要があって面倒なので、
;; tab-bar/tabspaces 系のよく使うコマンドを transient にまとめ、
;; project 用 (C-M-s-p) と揃えて C-M-s-t で開けるようにする。
;; タブそのものへのジャンプは M-1..M-9 (tab-bar-select-tab-modifiers)
;; があるのでここには含めない。

(require 'transient)

(transient-define-prefix my/tabspaces-transient ()
  "Tab / workspace commands."
  [["Workspace"
    ("s" "Switch/create workspace" tabspaces-switch-or-create-workspace)
    ("w" "Open project as workspace" tabspaces-open-or-create-project-and-workspace)]
   ["Tab"
    ("2" "New tab"      tab-new)
    ("0" "Close tab"    tab-close)
    ("1" "Close others" tab-close-other)
    ("r" "Rename tab"   tab-rename)
    ("u" "Undo close"   tab-undo)]
   ["Move"
    ("o" "Next tab" tab-next)
    ("O" "Prev tab" tab-previous)]])

(global-set-key (kbd "C-M-s-t") #'my/tabspaces-transient)
