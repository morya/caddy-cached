# caddyserver 通过 xcaddy 集成 cache-handler

我当前公司的项目，已经使用 caddy server 作为 reverse proxy，
同时使用方式是 docker compose 模型，image选用了 

`m.daocloud.io/docker.io/caddy:2.10-alpine`

## 详细要求

帮我使用 xcaddy 指令，并集成 cache-handler 插件 ，
构建出 amd64,arm64 双 os platform 的，基于  alpine 的镜像

- 推送代码到 github 仓库，地址 git@github.com:morya/caddy-cached.git
- 为仓库创建 github actions,提供 docker image build 能力，然后，构建出来的image，直接推送到 github image registry,而不是 docker image hub


