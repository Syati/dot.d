# mise 本体だけをイメージに焼き込む（SHA256 固定）。他のツールは install フックで mise が入れる。
# files/ は kit ディレクトリ（ビルドコンテキスト）から /usr/share/dev-tools/ に同梱する。
FROM debian:bookworm-slim AS build
ARG TARGETARCH
ARG MISE_VERSION=2026.11.12
ARG MISE_SHA256_ARM64=9a125763f8445ea28d2da0e943fe5ad7d81b397d78f173cc07c1cc18ee2bee47
ARG MISE_SHA256_AMD64=4b029e19afc575875a4962dfe5d5e31cc93ab0317242768d0234adec219d3e14
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl libatomic1 \
 && rm -rf /var/lib/apt/lists/*
RUN set -eux; \
    case "$TARGETARCH" in \
      arm64) MISE_ARCH=arm64; MISE_SHA="$MISE_SHA256_ARM64" ;; \
      amd64) MISE_ARCH=x64;   MISE_SHA="$MISE_SHA256_AMD64" ;; \
      *) echo "unsupported arch: $TARGETARCH" >&2; exit 1 ;; \
    esac; \
    mkdir -p /out/usr/local/bin /tmp/mise; \
    curl -fsSL -o /tmp/mise.tgz "https://github.com/jdx/mise/releases/download/v${MISE_VERSION}/mise-v${MISE_VERSION}-linux-${MISE_ARCH}.tar.gz"; \
    echo "${MISE_SHA}  /tmp/mise.tgz" | sha256sum -c -; \
    tar -xzf /tmp/mise.tgz -C /tmp/mise mise/bin/mise; \
    install -m 0755 /tmp/mise/mise/bin/mise /out/usr/local/bin/mise; \
    LIBDIR=$(dirname $(ls /usr/lib/*-linux-gnu/libatomic.so.1)); \
    mkdir -p "/out$LIBDIR"; \
    cp -a "$LIBDIR"/libatomic.so.1* "/out$LIBDIR/"

COPY files/ /out/usr/share/dev-tools/

FROM scratch
COPY --from=build /out/ /
