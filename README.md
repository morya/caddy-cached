# Caddy with Cache Handler

基于 Alpine 的 Caddy 镜像，集成了 [cache-handler](https://github.com/caddyserver/cache-handler) 插件，支持 amd64 和 arm64 架构。

## 功能特性

- 基于 Alpine Linux 的轻量级镜像
- 集成 cache-handler 插件，提供分布式 HTTP 缓存功能
- 支持多平台构建 (linux/amd64, linux/arm64)
- 自动构建并推送到 GitHub Container Registry

## 使用方式

### 从 GitHub Container Registry 拉取

```bash
docker pull ghcr.io/morya/caddy-cached:latest
```

### 使用 docker-compose

```yaml
version: '3.8'

services:
  caddy:
    image: ghcr.io/morya/caddy-cached:latest
    ports:
      - "80:80"
      - "443:443"
      - "2019:2019"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
    restart: unless-stopped

volumes:
  caddy_data:
  caddy_config:
```

### 本地构建

```bash
# 构建镜像
docker build -t caddy-cached .

# 运行容器
docker run -p 80:80 -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile:ro caddy-cached
```

## 缓存配置示例

在 Caddyfile 中启用缓存：

```caddy
{
    cache {
        ttl 120s
        stale 60s
    }
}

example.com {
    cache
    reverse_proxy backend:8080
}
```

## GitHub Actions 工作流

本项目配置了 GitHub Actions 工作流，在以下情况下自动构建和推送镜像：

- 推送到 `main` 分支
- 创建版本标签（如 `v1.0.0`）
- 手动触发工作流

镜像将推送到 GitHub Container Registry：`ghcr.io/morya/caddy-cached`

## 许可证

Apache-2.0