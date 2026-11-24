#!/bin/sh
# Docker Sandboxes (sbx) のユーザー設定。何度実行しても同じ結果になる。
# 現在の上書き値は `sbx settings ls` の SOURCE が override の行で確認できる。

if ! type sbx > /dev/null 2>&1; then
    echo 'sbx not found, skip sbx settings'
    exit 0
fi

# クリップボード連携（ホスト <-> サンドボックス）
sbx settings set clipboard.imagePaste true
sbx settings set clipboard.textCopy true

# サンドボックスの /var/lib/docker ボリュームのサイズ。
# 変更後に作ったサンドボックスにだけ効く（既存のものは拡張されない）。
sbx settings set sandbox.disk.dockerVolume 20g

# ネットワークポリシー: 既定の Balanced に足す分。ワイルドカードは使わずホストを個別に許可する。
# 許可済みなら何もしない（何度実行しても重複しない）。
allow_host() {
    if sbx policy check network "$1" 2>&1 | grep -q 'Allowed:'; then
        echo "already allowed: $1"
    else
        sbx policy allow network "$1"
    fi
}

# newkagg の docker compose: OpenSearch イメージ (public.ecr.aws) のレイヤー配信先と配布物
allow_host d5l0dvt14r5h8.cloudfront.net:443   # ECR Public のレイヤー本体 (CloudFront)
allow_host artifacts.opensearch.org:443       # OpenSearch のプラグインなど
# newkagg の bundle install
allow_host index.rubygems.org:443             # RubyGems のインデックス
