# 构建阶段使用纯 Go SQLite，显式关闭 CGO。
FROM golang:1.25-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/robinhood-meme ./cmd/app
# named volume 首次挂载会继承镜像目录权限；65532 是 distroless nonroot。
RUN mkdir -p /out/data && chown 65532:65532 /out/data

# 运行阶段只包含二进制、CA 证书和线性迁移文件。
FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app
COPY --from=build /out/robinhood-meme /app/robinhood-meme
COPY migrations /app/migrations
COPY --from=build --chown=65532:65532 /out/data /data
USER nonroot:nonroot
EXPOSE 8888
ENTRYPOINT ["/app/robinhood-meme"]
