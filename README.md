# Robinhood Meme v1

Robinhood Chain（chainId `4663`）新盘发现、聪明钱包流水与只读查询服务。当前代码遵循 `docs/功能模块/` 的物理目录、自然键和单 SQLite writer 约束；不包含私钥、下单或自动交易。

## 本地开发

要求 Go 1.25 或更高版本。

```bash
go mod download
go test ./internal/domain ./internal/store ./internal/config ./internal/logx
```

运行配置只来自环境变量。`RH_RPC_URL` 必填；常用本地覆盖为：

```bash
export RH_RPC_URL='https://your-rpc.example'
export RH_SQLITE_PATH='./data/robinhood_meme.sqlite3'
export RH_HTTP_ADDR='127.0.0.1:8888'
```

完整变量、默认值与校验规则见 `docs/功能模块/17-配置启动与Docker.md`。

## 数据与迁移

- SQLite 使用 WAL、`busy_timeout=5000`、外键和单 writer 队列。
- 启动时按文件名执行 `migrations/`，已执行文件的校验和不得变化。
- `wallet_events` 以链上时间保留 7 天，并经同一 writer 分批删除。
- 本地数据库放在 `data/`；数据库文件和 `.env` 不提交。

备份时应先停写，或使用 SQLite `VACUUM INTO` 创建一致副本。

## Docker

将实际配置写入不入库的 `.env`，再执行：

```bash
docker compose up --build
```

Compose 仅把 `127.0.0.1:8888` 暴露到主机，并使用 Docker named volume
`robinhood-data` 持久化 `/data`。首次启动不依赖主机目录权限，也无需以 root
执行 `chmod`。`docker compose down` 会保留数据；只有显式执行
`docker compose down -v` 才会删除本地数据库卷。镜像不复制 `.env`、数据库或文档。

## 文档

- [功能模块索引](docs/功能模块/README.md)
- [代码目录与文件清单](docs/功能模块/19-代码目录与文件清单.md)
- [系统架构](docs/架构/01-系统架构.md)
