;;; -*- lexical-binding: t -*-
;; define-sequential-command (sequential-command パッケージのマクロ) を
;; 下の :config で使うため、byte-compile 時にもマクロとして見えるよう
;; 明示的に require する。無いと関数呼び出しとしてコンパイルされてしまい
;; "Symbol's value as variable is void" になる。
(eval-when-compile
  (require 'sequential-command))

(use-package magit
  :ensure t
  :defer t
  :init
  (bind-keys* ("C-x g" . magit-status)
              ("C-x M-g" . magit-dispatch))
  ;; project-vc-dir (組み込みvc-dir) より magit-status の方が使いやすいので上書き
  (define-key project-prefix-map "v" #'magit-status)
  :config
  (setq magit-visit-ref-behavior '(checkout-any focus-on-ref))
  ;; M-1..M-4 は magit 標準でセクション折りたたみレベル一括設定
  ;; (magit-section-show-level-N-all) に割り当たっているが、ace-window の
  ;; one-shot window jump (30-ace-window.el) と衝突する。window jump を
  ;; 優先し、magit 側は外す。
  (dolist (n (number-sequence 1 4))
    (define-key magit-section-mode-map (kbd (format "M-%d" n)) nil))
  ;; 外した M-1..M-4 の代替。sequential-command (80-sequential-command-config.el
  ;; で導入済み) の define-sequential-command で、TAB 連打が
  ;; toggle → level-1-all → level-2-all → level-3-all → level-4-all
  ;; と進むようにする。別セクションに移動すれば (last-command が変わるので)
  ;; toggle からやり直しになり、普段の1セクションずつの開閉には影響しない。
  (define-sequential-command my/magit-section-cycle-tab
    magit-section-toggle
    magit-section-show-level-1-all
    magit-section-show-level-2-all
    magit-section-show-level-3-all
    magit-section-show-level-4-all)
  (define-key magit-section-mode-map (kbd "TAB") #'my/magit-section-cycle-tab)
  ;; <backtab> (Shift-TAB) は逆順 (level-4-all → ... → toggle) にする。
  ;; 元は magit-section-cycle-global (バッファ全体の折りたたみ順送り) が
  ;; 割り当たっていたが、これに譲る。
  (define-sequential-command my/magit-section-cycle-tab-reverse
    magit-section-show-level-4-all
    magit-section-show-level-3-all
    magit-section-show-level-2-all
    magit-section-show-level-1-all
    magit-section-toggle)
  (define-key magit-section-mode-map (kbd "<backtab>") #'my/magit-section-cycle-tab-reverse)
  )
