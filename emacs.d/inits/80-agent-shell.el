;;; -*- lexical-binding: t -*-
;; Claude Code / Codex それぞれ用の ACP アダプタが別途必要:
;; https://github.com/agentclientprotocol/claude-agent-acp
;; https://github.com/agentclientprotocol/codex-acp
;; 認証はどちらもデフォルトの (:login t) で、既存の claude / codex CLI の
;; ログインをそのまま使う (agent-shell-anthropic-authentication /
;; agent-shell-openai-authentication)。
;; :ensure-system-package のセットアップは 10-use-package-ensure-system-package.el 参照。

(use-package agent-shell
  :ensure t
  :defer t
  :ensure-system-package
  ((claude . "brew install claude-code")
   (claude-agent-acp . "npm install -g @agentclientprotocol/claude-agent-acp")
   (codex . "npm install -g @openai/codex")
   (codex-acp . "npm install -g @agentclientprotocol/codex-acp")
   (pngpaste . "brew install pngpaste"))
  :init
  (setq agent-shell-session-restore-verbosity 'full)
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
             agent-shell-toggle-logging)
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
