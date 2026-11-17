;;; -*- lexical-binding: t -*-
;; Claude Code / Codex それぞれ用の ACP アダプタが別途必要:
;; https://github.com/agentclientprotocol/claude-agent-acp
;; https://github.com/agentclientprotocol/codex-acp
;; 認証はどちらもデフォルトの (:login t) で、既存の claude / codex CLI の
;; ログインをそのまま使う (agent-shell-anthropic-authentication /
;; agent-shell-openai-authentication)。
;; :ensure-system-package のセットアップは 10-use-package-ensure-system-package.el 参照。

;; ACP アダプタの自動更新。
;; シェル起動時にピッカーへ出るモデル一覧 (session/new の availableModels) は
;; アダプタが同梱する Claude Agent SDK 由来なので、アダプタが古いままだと新しい
;; モデルが選べない。:ensure-system-package は「無ければ入れる」だけで更新は
;; しないため、ここで一日一回だけ非同期に更新をかける。
;;
;; アダプタは mise の npm backend で入れる前提 (下の :ensure-system-package)。
;; `npm install -g' だと node のバージョンごとの lib/node_modules に入るため、
;; mise で node を切り替えているとディレクトリ次第でアダプタが見つからない/
;; 古い版が使われる、という状態になる。mise 管理ならどの node でも同じ版。
(defvar my/agent-shell-acp-update-command
  (list (expand-file-name "~/.local/bin/mise") "upgrade" "--global"
        "npm:@agentclientprotocol/claude-agent-acp"
        "npm:@agentclientprotocol/codex-acp")
  "ACP アダプタを更新するコマンド。
mise は PATH 非依存の絶対パスで呼び、`--global' で更新対象を
グローバル設定に固定する (バッファの `default-directory' に依存させない)。")

(defvar my/agent-shell-acp-update-interval (* 24 60 60)
  "ACP アダプタの更新チェック間隔 (秒)。")

(defvar my/agent-shell-acp-update-stamp
  (expand-file-name "agent-shell-acp-update" user-emacs-directory)
  "最後に更新チェックした時刻を mtime で持つスタンプファイル。")

(defun my/agent-shell-acp--due-p ()
  "前回の更新チェックから `my/agent-shell-acp-update-interval' 経過したか。"
  (let ((mtime (file-attribute-modification-time
                (file-attributes my/agent-shell-acp-update-stamp))))
    (or (null mtime)
        (> (float-time (time-since mtime))
           my/agent-shell-acp-update-interval))))

(defun my/agent-shell-update-acp-adapters (&optional force)
  "ACP アダプタを非同期で更新する。
前回チェックから `my/agent-shell-acp-update-interval' 経過していなければ
何もしない。FORCE (C-u) で間隔を無視する。"
  (interactive "P")
  (when (and (or force (my/agent-shell-acp--due-p))
             (file-executable-p (car my/agent-shell-acp-update-command)))
    ;; 走らせる前にスタンプを更新する。オフラインや失敗時に Emacs 起動ごと
    ;; 再試行しないよう、成功/失敗ではなく「試した時刻」を記録する。
    (write-region "" nil my/agent-shell-acp-update-stamp nil 'silent)
    (let ((buffer (get-buffer-create "*acp-update*")))
      (with-current-buffer buffer (erase-buffer))
      (make-process
       :name "acp-update"
       :buffer buffer
       :noquery t
       :command my/agent-shell-acp-update-command
       :sentinel
       (lambda (process _event)
         (when (memq (process-status process) '(exit signal))
           (let ((code (process-exit-status process))
                 (output (if (buffer-live-p (process-buffer process))
                             (with-current-buffer (process-buffer process)
                               (buffer-string))
                           "")))
             (cond
              ((/= code 0)
               (message "ACP アダプタの更新に失敗 (exit %d)。*acp-update* 参照" code))
              ;; 更新が無いときは mise も何も出さないので、出力があった
              ;; ときだけ通知する。走っているシェルには反映されない。
              ((string-match-p "[^ \t\n]" output)
               (message "ACP アダプタを更新した。agent-shell 再起動 (C-c C-l) で反映"))))))))))

(use-package agent-shell
  :ensure t
  :defer t
  :ensure-system-package
  ((claude . "brew install claude-code")
   (claude-agent-acp . "mise use -g npm:@agentclientprotocol/claude-agent-acp@latest")
   (codex . "npm install -g @openai/codex")
   (codex-acp . "mise use -g npm:@agentclientprotocol/codex-acp@latest")
   (pngpaste . "brew install pngpaste"))
  :init
  (setq agent-shell-session-restore-verbosity 'full)
  ;; 起動直後は避け、アイドルしてから一度だけ更新チェック (更新は以降に
  ;; 新規起動するシェルから効く)。
  (run-with-idle-timer 180 nil #'my/agent-shell-update-acp-adapters)
  ;; 30-agent-shell-transient.el から呼ぶが autoload cookie が無いコマンド群
  ;; (package 側で agent-shell-restart 等と違い autoload 未登録のため、
  ;; :defer t のままだと transient-setup が "not defined or autoloaded" で失敗する)
  :commands (agent-shell-switch-buffer
             agent-shell-other-buffer
             agent-shell-send-file
             agent-shell-send-region-to
             agent-shell-send-clipboard-image
             agent-shell-send-screenshot
             agent-shell-interrupt
             agent-shell-copy-last-output
             agent-shell-toggle-logging
             agent-shell-set-session-mode
             agent-shell-set-session-model)
  :bind (("C-c C-a" . agent-shell-anthropic-start-claude-code)
         ("C-c C-o" . agent-shell-openai-start-codex)
         ("C-c C-w" . agent-shell)
         ("C-c C-l" . agent-shell-restart)
  )
  :config
  ;; tabspaces のセッション保存/復元に agent-shell バッファを対応させる。
  ;; `agent-shell-session-id' が返す ACP セッションIDはエージェント種別を
  ;; 持たない生の文字列で、種別 (:identifier, 例 'claude-code) は
  ;; `agent-shell-get-config' 側にしかないため、両方保存しておいて
  ;; 復元時に `agent-shell-agent-configs' から一致する設定を引き直す。
  ;; `agent-shell-resume-session' は種別をユーザーに選ばせる/自動推測する
  ;; 対話用の関数なので、無人復元では使えない。
  (defun my/agent-shell--config-for-identifier (identifier)
    "Return the agent-shell config alist whose :identifier is IDENTIFIER."
    (seq-find (lambda (config) (eq (map-elt config :identifier) identifier))
              (mapcar (lambda (entry) (if (functionp entry) (funcall entry) entry))
                      (if (functionp agent-shell-agent-configs)
                          (funcall agent-shell-agent-configs)
                        agent-shell-agent-configs))))
  (tabspaces-register-buffer-kind
   'agent-shell
   (lambda (b)
     (with-current-buffer b
       (when (derived-mode-p 'agent-shell-mode)
         (let ((session-id (agent-shell-session-id :shell-buffer b))
               (identifier (map-elt (agent-shell-get-config b) :identifier)))
           ;; セッションIDが無い (まだ何も送信していない) shell は
           ;; resume しようがないのでスキップする。
           (when (and session-id identifier
                      ;; 再接続 (reload/reconnect) すると同じ session-id を
                      ;; 指す古いバッファ (Foo, Foo<2>, Foo<3>...) が生き
                      ;; 残ったままになることがある。全部を別レコードとして
                      ;; 保存すると復元時に同じセッションを複数回 resume
                      ;; してしまうので、`buffer-list' の MRU 順で一番手前
                      ;; (=直近使ったもの) の1つだけを残す。
                      (eq b (seq-find
                             (lambda (ob)
                               (and (buffer-live-p ob)
                                    (with-current-buffer ob
                                      (and (derived-mode-p 'agent-shell-mode)
                                           (equal (agent-shell-session-id :shell-buffer ob)
                                                  session-id)))))
                             (buffer-list))))
             (list :kind 'agent-shell
                   :dir default-directory
                   :name (buffer-name)
                   :session-id session-id
                   :identifier identifier))))))
   (lambda (rec)
     (let* ((name (plist-get rec :name))
            (dir (plist-get rec :dir))
            (session-id (plist-get rec :session-id))
            (identifier (plist-get rec :identifier))
            (config (my/agent-shell--config-for-identifier identifier)))
       (cond
        ((not (and dir (stringp dir) (file-directory-p dir))) nil)
        ((not config)
         (message "tabspaces: agent-shell restore skipped, no config for %S" identifier)
         nil)
        (t (or (tabspaces-reuse-existing-buffer name)
               (condition-case err
                   (let* ((default-directory dir)
                          (buf (agent-shell-start :config config :session-id session-id)))
                     (when (and buf
                                (not (equal name (buffer-name buf)))
                                (not (get-buffer name)))
                       (with-current-buffer buf (rename-buffer name)))
                     buf)
                 (error
                  (message "tabspaces: agent-shell restore skipped (%s): %S" dir err)
                  nil)))))))))
