# 使用多阶段构建优化版本
# 构建参数，用于控制缓存
ARG BUILDKIT_INLINE_CACHE=1

# 第一阶段：依赖准备和缓存
FROM golang:1.25-alpine AS deps

# 设置 Go 模块代理加速下载
ENV GOPROXY=https://proxy.golang.org,direct
ENV GOSUMDB=sum.golang.org

# 设置工作目录
WORKDIR /build

# 复制 go.mod 文件并预下载依赖
COPY go.mod .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download

# 安装 xcaddy
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# 第二阶段：构建 Caddy 二进制
FROM deps AS builder

# 复制构建脚本
COPY build.sh .

# 构建 Caddy 二进制，使用缓存
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    ./build.sh

# 第三阶段：创建最终镜像
FROM alpine:3.21

# 安装必要的运行时依赖
RUN apk add --no-cache ca-certificates mailcap

# 创建非 root 用户
RUN addgroup -g 1000 -S caddy && \
    adduser -u 1000 -S caddy -G caddy

# 从构建阶段复制 Caddy 二进制
COPY --from=builder /build/caddy /usr/bin/caddy

# 设置权限
RUN chmod 755 /usr/bin/caddy

# 创建必要的目录
RUN mkdir -p /config /data
RUN chown -R caddy:caddy /config /data

# 切换到非 root 用户
USER caddy

# 设置工作目录
WORKDIR /config

# 暴露端口
EXPOSE 80 443 2019

# 设置 Caddy 运行命令
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]