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

利用方法
------------------------------

```sh
git git@github.com:Syati/emacs.d.git .emacs.d
```

emacs 立ち上げ時に、.emacs.d に記述のあるパッケージを自動で取得・インストールします。
ただし、失敗することがある？ので、その場合は再起動。

利用にあたりあったら良いパッケージ
----------------------------------

* フォントを綺麗にしたい場合は以下をインストールしてください。すでに設定がされているのでインストール次第適用されます。
    * inconsolata
    * tty-takao
* gtags を利用しているため、以下のパッケージをDLして make, make install
    * [gnu global](http://www.gnu.org/software/global/)

