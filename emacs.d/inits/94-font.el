;;; -*- lexical-binding: t -*-
;; 英字: JetBrains Mono / 日本語: Hiragino Sans (macOS 内蔵)
;;
;; daemon 起動時は表示に繋がっていないため font-family-list が空を返し、
;; この設定がスキップされてしまう。emacsclient -c で新しいフレームを作る
;; たびに (再)適用することで、daemon 経由でも正しいフォントが当たるようにする。
(defun my/setup-fonts-1 (frame)
  (when (and (member "JetBrains Mono" (font-family-list frame))
             (member "Hiragino Sans" (font-family-list frame)))

    (set-face-attribute 'default frame
                         :family "JetBrains Mono"
                         :height 140)

    (set-fontset-font
     (frame-parameter frame 'font)
     'japanese-jisx0208
     '("Hiragino Sans" . "iso10646-1"))

    (set-fontset-font
     (frame-parameter frame 'font)
     'japanese-jisx0212
     '("Hiragino Sans" . "iso10646-1"))

    (set-fontset-font
     (frame-parameter frame 'font)
     'mule-unicode-0100-24ff
     '("JetBrains Mono" . "iso10646-1"))

    ;; 半角カタカナ、全角アルファベットの設定
    (set-fontset-font nil
                       '(#xff00 . #xffef)
                       (font-spec :family "Hiragino Sans")
                       nil
                       'prepend)

    ;; 記号、全角ひらがな、全角カタカナの設定
    (set-fontset-font nil
                       '(#x3000 . #x30ff)
                       (font-spec :family "Hiragino Sans")
                       nil
                       'prepend)

    ;; フォントの横幅の調整
    (setq face-font-rescale-alist
          '((".*JetBrains Mono.*" . 1.0)
            (".*Hiragino Sans.*" . 1.0)
            (".*Hiragino Mincho Pro.*" . 1.0)
            (".*HannariMincho.*" . 1.0)
            ("-cdac$" . 1.3)))))

;; フレーム生成直後は set-fontset-font がエラーになることがあり、
;; そのエラーが after-make-frame-functions の残りのフック(タイトルバー
;; 設定など)まで巻き込んで止めてしまうため、必ず遅延実行にする。
(defun my/setup-fonts (&optional frame)
  (run-with-timer 0.3 nil #'my/setup-fonts-1 frame))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'my/setup-fonts)
  (my/setup-fonts))
