(when (>= emacs-major-version 23)
  (when (find (and "TakaoGothic" "Inconsolata") (font-family-list) :test #'equal)

    (set-face-attribute 'default nil
                        :family "Inconsolata"
                        :height 180)

    (set-fontset-font
     (frame-parameter nil 'font)
     'japanese-jisx0208
     '("TakaoExGothic" . "iso10646-1"))

    (set-fontset-font
     (frame-parameter nil 'font)
     'japanese-jisx0212
     '("TakaoExGothic" . "iso10646-1"))

    (set-fontset-font
     (frame-parameter nil 'font)
     'mule-unicode-0100-24ff
     '("Inconsolata" . "iso10646-1"))

    ;; 半角カタカナ、全角アルファベットの設定
    (set-fontset-font nil
                      '( #xff00 . #xffef)
                      (font-spec :family "TakaoExGothic")
                      nil
                      'prepend)

    ;; 記号、全角ひらがな、全角カタカナの設定
    (set-fontset-font nil
                      '( #x3000 . #x30ff)
                      (font-spec :family "TakaoExGothic"
                                 nil
                                 'prepend))
    ;; フォントの横幅の調整
    (setq face-font-rescale-alist
          '((".*Inconsolata.*" . 1.0)
            (".*Hiragino Mincho Pro.*" . 1.0)
            (".*TakaoExGothic.*" . 1.0)
            (".*HannariMincho.*" . 1.0)
            ("-cdac$" . 1.3)))))
