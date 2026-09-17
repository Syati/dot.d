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
;; セッションの自動保存/自動復元/手動復元 (tabspaces-session 系) は、
;; 復元処理まわりで次々に不具合 (GUIフリーズ、"*Old buffer*" の誤表示、
;; 後始末漏れの残留タブ、*tabspaces--placeholder* バッファの増殖) が
;; 出て枯れていなかったため、一旦まるごと無効化している。ワークスペースの
;; 手動切り替え・作成 (C-x t s, C-x p p 連携) には影響しない。
(tab-bar-mode 1)
(setq tab-bar-show 1
      tab-bar-close-button-show 'selected
      tab-bar-new-button-show nil
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
  ;; セッションの保存/自動復元/手動復元は一旦すべて無効化 (上のコメント参照)
  (tabspaces-session nil)
  (tabspaces-session-auto-restore nil)
  :bind (("C-x t s" . tabspaces-switch-or-create-workspace)
         ("C-x t w" . tabspaces-open-or-create-project-and-workspace)))
