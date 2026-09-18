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

  ;; tabspaces--buffer-list (tabspaces.el) はタブ番号 (tabnum) 指定で
  ;; そのタブのバッファ一覧を返せる唯一の手段 (公開版の
  ;; tabspaces-local-buffer-list はカレントタブ専用) なので、内部関数だが
  ;; ここから使い、BUFFER がどのタブに属すか逆引きする
  (defun my/consult--tab-number-of-buffer (buffer)
    "Return the 1-based tab-bar number of the tab BUFFER belongs to, or nil."
    (let ((tabs (frame-parameter nil 'tabs)) (i 0) found)
      (while (and tabs (not found))
        (when (memq buffer (tabspaces--buffer-list nil i))
          (setq found (1+ i)))
        (setq tabs (cdr tabs) i (1+ i)))
      found))

  ;; 番号をそのまま埋め込むと目立ちすぎるので shadow face で薄く見せる。
  ;; 文字自体は残るので絞り込み検索の対象にはなる
  (defun my/consult--tab-number-prefix (n name)
    "Prepend NAME with tab number N shown in a dim face; NAME unchanged if N is nil."
    (if n (concat (propertize (format "%d " n) 'face 'shadow) name) name))

  ;; consult--buffer-action (consult.el 標準) は常にカレントウィンドウで
  ;; switch-to-buffer するので、別タブのバッファを選ぶとそのバッファが
  ;; 元のタブから奪われたようにカレントタブのウィンドウに出てしまう
  ;; (tab2 にいる状態で tab1 のバッファを選ぶと tab2 に開かれる)。選んだ
  ;; バッファが別タブに属していれば、先にそのタブへ切り替えてから開く
  (defun my/consult--buffer-action (buffer &optional norecord)
    "Like `consult--buffer-action', but select BUFFER's own tab first
when it differs from the current tab, and focus BUFFER's existing
window within that tab instead of replacing the current window's
buffer when it is already displayed there."
    (when-let* ((buf (get-buffer buffer))
                (n (my/consult--tab-number-of-buffer buf))
                ((/= n (1+ (tab-bar--current-tab-index)))))
      (tab-bar-select-tab n))
    ;; `get-buffer-window' restricted to the selected frame only sees
    ;; windows of the now-current tab (other tabs' windows are not part
    ;; of the live window list), so this also covers the just-switched-to
    ;; tab from above.
    (if-let* ((win (get-buffer-window buffer (selected-frame))))
        (select-window win norecord)
      (consult--buffer-action buffer norecord)))

  (defun my/consult--buffer-state ()
    "Like `consult--buffer-state', but commit via `my/consult--buffer-action'."
    (consult--state-with-return (consult--buffer-preview) #'my/consult--buffer-action))

  ;; 標準の "Buffer" source にもタブ番号を付け、agent-shell のバッファは
  ;; 専用の "Agent Shell" source と重複するので除外する。consult-customize は
  ;; :items に渡した式を quote してから eval するため、外側の let で
  ;; キャプチャした値を閉じ込められない。そのため plist-put で直接
  ;; consult-source-buffer の :items を差し替える。
  ;; consult.el 本体の consult-source-buffer 定義 (consult--buffer-query
  ;; :sort 'visibility :as #'consult--buffer-pair) を直接呼ぶようにし、
  ;; 現在の :items 値を捕まえて包む方式にしない。後者だと、この :config が
  ;; 2回以上実行された場合 (init ファイルを手動で load-file し直した時など)
  ;; に前回ラップした関数をさらにラップしてしまい、番号が "2 2 2 name" の
  ;; ように重複する
  (plist-put consult-source-buffer :items
             (lambda ()
               (let* ((agent-shell-bufs (and (fboundp 'agent-shell-buffers)
                                             (agent-shell-buffers)))
                      ;; タブ番号を (n . pair) として一旦キープしておき、
                      ;; 後で並べ替える。visibility 順のままだとタブ所属を
                      ;; 考慮しないので、無所属バッファ (n が nil、
                      ;; *Messages* 等の特殊バッファやオーファン) やタブが
                      ;; 混ざって出てくる
                      (tagged (mapcar (lambda (pair)
                                        (let ((n (my/consult--tab-number-of-buffer (cdr pair))))
                                          (cons n (if n
                                                      (cons (my/consult--tab-number-prefix n (car pair)) (cdr pair))
                                                    pair))))
                                      (seq-remove (lambda (pair) (memq (cdr pair) agent-shell-bufs))
                                                  (consult--buffer-query :sort 'visibility
                                                                         :as #'consult--buffer-pair))))
                      ;; 各グループ内は visibility 順を保ったまま、タブ番号
                      ;; の昇順でグループごとにまとめる。seq-filter は順序を
                      ;; 保つので `sort' の安定性に頼らずに済む
                      (tab-numbers (sort (delete-dups (delq nil (mapcar #'car tagged))) #'<)))
                 (mapcar #'cdr
                         (append (mapcan (lambda (n)
                                           (seq-filter (lambda (p) (equal (car p) n)) tagged))
                                         tab-numbers)
                                 (seq-remove #'car tagged))))))
  (plist-put consult-source-buffer :state #'my/consult--buffer-state)

  ;; consult-buffer に agent-shell のバッファも候補として追加する。
  ;; agent-shell は :defer t なので、まだ一度も使っていない (ライブラリ未ロード)
  ;; 状態で agent-shell-buffers を呼ぶと void-function になるため fboundp で guard する。
  ;; 表示名の先頭にタブ番号 (tab-bar-tab-hints と同じ番号) を付けて、
  ;; どのワークスペースのバッファかひと目で分かるようにする
  (defvar consult--source-agent-shell
    `(:name "Agent Shell"
      :narrow ?a
      :category buffer
      :face consult-buffer
      :state ,#'my/consult--buffer-state
      :action ,#'my/consult--buffer-action
      :items ,(lambda ()
                (when (fboundp 'agent-shell-buffers)
                  ;; agent-shell-buffers is agent-shell's own tracking list,
                  ;; not Emacs's live buffer-list, so it can lag behind a
                  ;; buffer being killed out from under it (e.g. manual
                  ;; kill-buffer). A dead buffer here crashes Vertico when
                  ;; it tries to annotate/icon it, so filter first.
                  (mapcar (lambda (buf)
                            (let* ((name (buffer-name buf))
                                   (n (my/consult--tab-number-of-buffer buf)))
                              (cons (my/consult--tab-number-prefix n name) name)))
                          (seq-filter #'buffer-live-p (agent-shell-buffers))))))
    "Consult source for agent-shell buffers.")
  (add-to-list 'consult-buffer-sources 'consult--source-agent-shell)

  ;; consult-buffer に tab-bar のタブ (tabspaces のワークスペースも同じもの)
  ;; を候補として追加する。tab-bar-switch-to-tab は既存なら切り替え、
  ;; 無ければ新規作成してくれるので選択・新規作成の両方をこれ1つで賄える。
  ;; 表示名の先頭にタブ番号 (tab-bar-tab-hints / s-<数字> と同じ番号) を付ける。
  ;; 最後に add-to-list するので、他の source より前 (一番上) に来る
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
                (let ((n 0))
                  (mapcar (lambda (tab)
                            (setq n (1+ n))
                            (let ((name (alist-get 'name tab)))
                              (cons (my/consult--tab-number-prefix n name) name)))
                          (funcall tab-bar-tabs-function)))))
    "Consult source for tab-bar tabs.")
  (add-to-list 'consult-buffer-sources 'consult--source-tab-bar))
