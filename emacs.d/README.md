README
======
私的 emacs 設定ファイルを管理する場所。

想定環境
--------
* OS
    * ubuntu
    * MAC
    * その他
* emacs-ver
    * emacs24


高速化するために
------------------------------

以下で site-lisp をバイトコンパイル

```
C-u 0 M-x byte-recompile-directory
```

Font install
------------------------------

M-x nerd-icons-install-fonts でアイコン用フォントを入れてください



利用方法
------------------------------

```sh
git git@github.com:Syati/emacs.d.git .emacs.d
```

emacs 立ち上げ時に、.emacs.d に記述のあるパッケージを自動で取得・インストールします。
ただし、失敗することがある？ので、その場合は再起動。

利用にあたりあったら良いパッケージ
----------------------------------

* フォントを綺麗にしたい場合は以下をインストールしてください。すでに設定がされているのでインストール次第適用されます(英字: JetBrains Mono、日本語: Hiragino Sans は macOS 標準搭載のため別途インストール不要)。
    * [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
* gtags を利用しているため、以下のパッケージをDLして make, make install
    * [gnu global](http://www.gnu.org/software/global/)

daemon 化(macOS)
------------------------------

`osx/LaunchAgents/com.mizuki-y.emacs.daemon.plist` をログイン時に読み込ませることで、
GUI セッションに繋がった Emacs デーモンを常駐させられます。

```sh
ln -sf ~/.dot.d/osx/LaunchAgents/com.mizuki-y.emacs.daemon.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/com.mizuki-y.emacs.daemon.plist
```

* ターミナルの `emacs` コマンドは `emacsclient -t -a ""` の alias になっており、
  デーモンが無ければ自動起動して繋がります(`zsh.d/.zshrc`)。
* GUI で新規ウィンドウを開きたい場合は `~/Applications/Emacs Client.app` を使ってください
  (Alfred/Spotlight から呼び出し可能)。既に GUI フレームがあれば使い回し、無ければ
  `emacsclient -c` で新規作成します。`osx/scripts/install-emacs-client-app.sh` を実行すると
  作成/再生成できます。
