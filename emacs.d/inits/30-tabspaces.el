;;; -*- lexical-binding: t -*-
;; プロジェクトごとにバッファ一覧とウィンドウ配置を分離する (旧 perspective.el)。
;;
;; perspective.el はフレーム単位で状態を保存/復元しており、
;; persp-state-load が保存されていたフレーム数ぶん make-frame-command を
;; 呼ぶ実装だったため、--fg-daemon + emacsclient の運用で新しいフレームを
;; 開くたびに過去のフレームまで再現されて増殖する問題があった。
;; tabspaces は tab-bar のタブとして状態を持つため、フレームを増やさずに
;; プロジェクト単位のワークスペース分離ができる。
;;
;; セッションの自動復元 (tabspaces-session-auto-restore) は、起動時の
;; 全タブ復元処理まわりで次々に不具合 (GUIフリーズ、"*Old buffer*" の
;; 誤表示、後始末漏れの残留タブ、*tabspaces--placeholder* バッファの増殖)
;; が出て枯れていなかったため、グローバルには無効化している。ワークスペースの
;; 手動切り替え・作成 (C-x t s, C-x p p 連携) には影響しない。
;;
;; 保存 (tabspaces-session) の方は別経路で、不具合が出ていた復元処理を
;; 一切経由しない (対象タブを巡回してファイルに書き出すだけ) ため有効化
;; している。tabspaces-session-project-session-store がデフォルト
;; 'project なので、プロジェクトごとに個別のセッションファイルへ保存される
;; (非プロジェクトのタブはグローバルファイルへ)。保存タイミングは Emacs
;; 終了時 (kill-emacs-hook) のみで、アイドル自動保存
;; (tabspaces-session-auto-save-delay) は有効にしていない。
;;
;; 「project を切り替えたときに、そのプロジェクト用の保存済みセッションが
;; あれば自動で復元する」だけは下の :config で個別に有効化している。
;; tabspaces-session-auto-restore をグローバルに t にすると起動時の
;; 全タブ復元 (上記の不具合の元) まで有効になってしまうため、
;; tabspaces-open-or-create-project-and-workspace の実行中だけ advice で
;; 動的に t にして、その関数内の対象コードパス
;; (project はあるが tab が無い → 新規タブ作成) だけに絞る。
(tab-bar-mode 1)
(setq tab-bar-show 1
      tab-bar-close-button-show 'selected
      ;; tab-bar-new-button-show (28.1で obsolete) の代替。"+" ボタンを
      ;; 描画する tab-bar-format-add-tab を外して非表示にする
      ;; (新規タブは C-x t 2 / tabspaces 経由で作るので不要)
      tab-bar-format (remq 'tab-bar-format-add-tab tab-bar-format)
      tab-bar-tab-hints t          ; タブ名の前に番号を表示
      tab-bar-tab-name-truncated-max 20)
;; 上の tab-bar-tab-hints は番号を表示するだけで、s-1 等で実際に選べる
;; ようにするにはこちらも必要 (0 は直前のタブ、9 は一番右のタブ)。
;; :set 関数でキーバインドを実インストールする変数なので setq ではなく
;; setopt (customize-set-variable 相当) を使う。
;; M-<数字> はウィンドウ切り替え (30-ace-window.el) に使うので、タブは
;; Super (s-<数字>) にしている。shift は数字キー列だと物理的に別記号
;; (Shift+1 = "!" 等) になってしまい S-M-<数字> という組み合わせを
;; 安定して送れないため使わない。
(setopt tab-bar-select-tab-modifiers '(super))

;; タブの見た目を凝らせようとして何度か試したが (SVGでの角丸描画、
;; Powerlineグリフでのピル型描画のどちらも) 、色の unspecified/nil 周りの
;; エラーや GUIフレーム生成直後のフリーズなど問題が続いたため、標準の
;; tab-bar 表示のまま見た目のカスタマイズはしないことにした。

(use-package tabspaces
  :ensure t
  :init
  (tabspaces-mode 1)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*"))
  ;; 組み込みの project-switch-project (C-x p p) をそのままタブ連携させる
  (tabspaces-project-switch-opens-workspace t)
  ;; プロジェクト単位の自動保存 (終了時のみ) は有効、自動復元は無効
  ;; (上のコメント参照)
  (tabspaces-session t)
  (tabspaces-session-auto-restore nil)
  :bind (("C-x t s" . tabspaces-switch-or-create-workspace)
         ("C-x t w" . tabspaces-open-or-create-project-and-workspace))
  :config
  (defun my/tabspaces--enable-project-session-auto-restore (orig-fun &rest args)
    "Run ORIG-FUN with `tabspaces-session-auto-restore' dynamically bound to t.
Named (rather than an anonymous lambda) so re-evaluating this file via
`advice-add' stays idempotent instead of stacking duplicate advice."
    (let ((tabspaces-session-auto-restore t))
      (apply orig-fun args)))
  (advice-add 'tabspaces-open-or-create-project-and-workspace :around
              #'my/tabspaces--enable-project-session-auto-restore)

  ;; --fg-daemon + emacsclient 運用では、C-x C-c (save-buffers-kill-terminal)
  ;; は「今の client 接続 (フレーム) を閉じるだけ」で daemon 自体は終了しない
  ;; ため、tabspaces-session の保存がぶら下がっている kill-emacs-hook が
  ;; 実質ほぼ発火しない (daemon を本当に kill-emacs するまで一切保存されない)。
  ;; C-x C-c のたびにも保存されるよう、明示的に差し込む。
  ;;
  ;; さらに、フレームを閉じてもそのタブが使っていたバッファ (vterm の
  ;; プロセスや agent-shell の ACP 接続) は kill されずオーファンとして
  ;; 生き残る。保存は済んでいるので古い方を残す意味は無く、放置すると
  ;; 次に開いたときの復元処理が同名で新規作成しようとして衝突する
  ;; (vterm は `*vterm*<2><2>' のような別名になり、agent-shell は同じ
  ;; session-id に2つ目の ACP クライアントが繋がってしまう)。プロセスを
  ;; 持つ kind (vterm/agent-shell/eshell/shell/eat) のバッファだけを
  ;; 対象に kill する。dired やファイル訪問バッファは対象外: これらは
  ;; `dired-noselect'/`find-file' が既存バッファを再利用するので衝突せず、
  ;; 未保存の編集を確認無しに破棄してしまうリスクもある
  ;; (save-buffers-kill-terminal 自身がこの直後に保存確認をするので、
  ;; そちらに任せる)。
  (defun my/tabspaces--kill-frame-tab-process-buffers ()
    "Kill process-backed buffers of every tab on the selected frame."
    (let ((kill-buffer-query-functions nil))
      (dolist (tab-name (tabspaces--list-tabspaces))
        (tab-bar-select-tab-by-name tab-name)
        (dolist (b (tabspaces--buffer-list))
          (when (with-current-buffer b
                  (derived-mode-p 'vterm-mode 'agent-shell-mode
                                  'eshell-mode 'shell-mode 'eat-mode))
            (kill-buffer b))))))
  (defun my/tabspaces--save-session-on-frame-close (&rest _args)
    "Save the tabspaces session and clean up its process buffers
before `save-buffers-kill-terminal' closes this frame."
    (tabspaces--save-session-smart)
    (my/tabspaces--kill-frame-tab-process-buffers))
  (advice-add 'save-buffers-kill-terminal :before
              #'my/tabspaces--save-session-on-frame-close))
