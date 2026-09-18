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
(setq tab-bar-show t
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
  ;; プロセスや agent-shell の ACP 接続、dired) は kill されずオーファン
  ;; として生き残る。保存は済んでいるので古い方を残す意味は無く、放置
  ;; すると次に開いたときの復元処理が同名で新規作成しようとして衝突する
  ;; (vterm は `*vterm*<2><2>' のような別名になり、agent-shell は同じ
  ;; session-id に2つ目の ACP クライアントが繋がってしまう)。
  ;; dired も対象: 復元処理はタブをまたいだ使い回しを避けるため
  ;; `dired-buffers' キャッシュを明示的にクリアしてから毎回新規作成する
  ;; 実装なので、オーファンが残っていると同様に衝突し、名前がずれた
  ;; オーファンが延々と生き残るループになる。ファイル訪問バッファは対象外:
  ;; `find-file' は既存バッファを素直に再利用するので衝突せず、未保存の
  ;; 編集を確認無しに破棄してしまうリスクもある (save-buffers-kill-terminal
  ;; 自身がこの直後に保存確認をするので、そちらに任せる)。dired は通常
  ;; 「未保存の編集」を持たないので同じ理由での除外対象にはならないが、
  ;; `wdired' 編集中 (buffer-modified-p) だけは保険として除外する。
  (defun my/tabspaces--kill-frame-tab-process-buffers ()
    "Kill process-backed and dired buffers of every tab on the selected frame.
Reports what it killed (or any error) via `message', since this runs
silently inside a `:before' advice on `save-buffers-kill-terminal' and
would otherwise leave no trace if it failed partway through."
    (let ((kill-buffer-query-functions nil)
          (killed nil)
          (seen nil))
      (condition-case err
          (dolist (tab-name (tabspaces--list-tabspaces))
            (tab-bar-select-tab-by-name tab-name)
            (let ((bufs (tabspaces--buffer-list)))
              (push (cons tab-name (mapcar #'buffer-name bufs)) seen)
              (dolist (b bufs)
                (when (and (buffer-live-p b)
                           (with-current-buffer b
                             ;; buffer-modified-p is only meaningful as a
                             ;; safety check for dired (protects an
                             ;; in-progress wdired edit); vterm/agent-shell/
                             ;; eshell/shell/eat buffers are considered
                             ;; "modified" just from ordinary process output,
                             ;; so gating on it there would exclude them
                             ;; unconditionally.
                             (and (derived-mode-p 'vterm-mode 'agent-shell-mode
                                                  'eshell-mode 'shell-mode 'eat-mode
                                                  'dired-mode)
                                  (or (not (derived-mode-p 'dired-mode))
                                      (not (buffer-modified-p))))))
                  (push (buffer-name b) killed)
                  (kill-buffer b)))))
        (error (message "tabspaces: frame-close buffer cleanup failed: %S" err)))
      (message "tabspaces: examined tabs: %S" (nreverse seen))
      (message "tabspaces: killed %d buffer(s) before frame close: %S"
               (length killed) killed)))
  (defun my/tabspaces--save-session-on-frame-close (&rest _args)
    "Save the tabspaces session and clean up its process buffers
before `save-buffers-kill-terminal' closes this frame."
    (tabspaces--save-session-smart)
    (my/tabspaces--kill-frame-tab-process-buffers))
  (advice-add 'save-buffers-kill-terminal :before
              #'my/tabspaces--save-session-on-frame-close)

  ;; タブ1を常に "home" という固定名の非プロジェクトタブにする。新規
  ;; フレームは無名タブ1つだけの状態で作られる (名前はカレントバッファ
  ;; 追従のデフォルト名) ので、明示的にリネームして固定する。既に "home"
  ;; という名前のタブがあれば何もしない (このファイルを再読み込みしても
  ;; 二重に走らない)
  (defun my/tabspaces--ensure-home-tab (&optional frame)
    "Ensure FRAME's first tab is named \"home\"."
    (with-selected-frame (or frame (selected-frame))
      (unless (member "home" (tabspaces--list-tabspaces))
        (tab-bar-rename-tab "home" 1))))
  (dolist (frame (frame-list))
    (my/tabspaces--ensure-home-tab frame))
  (add-hook 'after-make-frame-functions #'my/tabspaces--ensure-home-tab))
