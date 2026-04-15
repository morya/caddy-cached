#!/bin/sh

set -e

# 构建带 cache-handler 插件的 Caddy
xcaddy build \
    --with github.com/caddyserver/cache-handler \
    --output ./caddy

echo "Caddy with cache-handler built successfully"