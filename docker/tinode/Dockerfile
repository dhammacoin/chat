# Корневой Dockerfile
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Копируем только tinode
COPY tinode/ ./tinode

WORKDIR /app/tinode

RUN apk add --no-cache git gcc musl-dev
RUN go mod download

# Сборка Tinode
RUN go build -o tinode-server cmd/server/main.go
RUN go build -o init-db cmd/init-db/main.go

# --- Этап запуска ---
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/tinode/tinode-server .
COPY --from=builder /app/tinode/init-db .
COPY --from=builder /app/tinode/templ/ ./templ/
COPY --from=builder /app/tinode/static/ ./static/
COPY --from=builder /app/tinode/data/ ./data/
COPY --from=builder /app/tinode/tinode.conf .
COPY --from=builder /app/tinode/entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 6060
CMD ["./entrypoint.sh"]
