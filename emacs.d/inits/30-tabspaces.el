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
  ;; tabspaces-mode (define-minor-mode) は既に有効でも呼ぶたびに enable
  ;; 本体を無条件に再実行する実装で、その中の tab-bar 関連セットアップの
  ;; 再実行がタブの状態を壊すことがある (実際に何度も踏んだ)。C-z r
  ;; (my/reload-init, 95-keybind.el) で init.el 全体を読み直すたびに
  ;; ここも再評価されるので、既に有効なら呼ばないようガードする。
  (unless tabspaces-mode
    (tabspaces-mode 1))
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
  ;; C-x t 系の直接バインドは持たない。30-tabspaces-transient.el が
  ;; s-t にまとめており (s/w/h がここと同じコマンド)、C-x t は2打鍵とも
  ;; Ctrl を離す必要があって面倒という、まさにその transient を作った
  ;; 理由と重複するため。
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
  ;; 自身がこの直後に保存確認をするので、そちらに任せる)。`wdired' 編集中は
  ;; major-mode が `wdired-mode' になり `dired-mode' からの派生ではなくなる
  ;; ため (`derived-mode-p' が nil)、そもそもここで dired と判定されず
  ;; 自然に対象外になる。buffer-modified-p による保護は不要。
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
                             (derived-mode-p 'vterm-mode 'agent-shell-mode
                                             'eshell-mode 'shell-mode 'eat-mode
                                             'dired-mode)))
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

  ;; タブ1を常に "home" という固定名の非プロジェクトタブにし、~/ の
  ;; dired を開いておく。新規フレームは無名タブ1つだけの状態で作られる
  ;; (名前はカレントバッファ追従のデフォルト名) ので、明示的に ~/ を開いて
  ;; からリネームして固定する。既に "home" という名前のタブがあれば何も
  ;; しない (このファイルを再読み込みしても二重に走らない)。
  ;;
  ;; 非プロジェクトタブはセッションの保存はされる (tabspaces-session-file
  ;; へ) が、tabspaces-session-auto-restore はプロジェクトタブ用の advice
  ;; でしか動的に有効化していないため復元経路を一切通らない。保存/復元の
  ;; 往復に頼ると、"*Old buffer NAME*-PID" (window-state-put が復元先の
  ;; バッファを見失ったときのプレースホルダー) を踏んだ場合、直せないまま
  ;; 何度も保存し直されて延々と残ってしまう (実際に起きた)。それを避けて
  ;; 毎回ここで確実に ~/ を開き直す。
  (defun my/tabspaces--setup-home-buffer ()
    "Show ~/ in the current window and rename the current tab to \"home\"."
    (dired "~/")
    (tab-bar-rename-tab "home"))
  (defun my/tabspaces--ensure-home-tab (&optional frame)
    "Ensure FRAME's first (and, when fresh, only) tab is \"home\", showing ~/."
    (with-selected-frame (or frame (selected-frame))
      (unless (member "home" (tabspaces--list-tabspaces))
        (my/tabspaces--setup-home-buffer))))
  (dolist (frame (frame-list))
    (my/tabspaces--ensure-home-tab frame))
  (add-hook 'after-make-frame-functions #'my/tabspaces--ensure-home-tab)

  ;; C-x t h: 手動で home タブを閉じてしまった後の復帰用。既存の
  ;; my/tabspaces--ensure-home-tab は「フレームの唯一のタブを home に
  ;; 仕立てる」新規フレーム用の処理なので、他のタブが既にあるフレームで
  ;; そのまま使うとカレントタブを home に上書きしてしまい適さない。
  ;; こちらは常に新規タブを作ってから home に仕立てる。
  (defun my/tabspaces-open-home-tab ()
    "Switch to the \"home\" tab, recreating it at position 1 if closed."
    (interactive)
    (if (member "home" (tabspaces--list-tabspaces))
        (tab-bar-switch-to-tab "home")
      (tab-bar-new-tab)
      (my/tabspaces--setup-home-buffer)
      (tab-bar-move-tab-to 1))))
