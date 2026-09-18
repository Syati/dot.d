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
              #'my/tabspaces--enable-project-session-auto-restore))
