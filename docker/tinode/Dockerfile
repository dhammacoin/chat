# --- Этап сборки ---
FROM golang:1.21-alpine AS builder

# Устанавливаем зависимости для сборки
RUN apk add --no-cache git gcc musl-dev

WORKDIR /app

# Клонируем официальный репозиторий Tinode
RUN git clone https://github.com/tinode/chat.git .

# Собираем сервер и утилиту инициализации базы
RUN go build -o tinode-server cmd/server/main.go
RUN go build -o init-db cmd/init-db/main.go

# --- Этап запуска ---
FROM alpine:3.18

WORKDIR /app

# Копируем бинарники и ресурсы
COPY --from=builder /app/tinode-server .
COPY --from=builder /app/init-db .
COPY --from=builder /app/server/templ/ ./templ/
COPY --from=builder /app/server/static/ ./static/
COPY --from=builder /app/scripts/data/ ./data/

# Конфиг и скрипт запуска
COPY config.template ./tinode.conf
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Открываем порт Tinode
EXPOSE 6060

# Команда запуска
CMD ["./entrypoint.sh"]
