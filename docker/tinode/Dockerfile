FROM golang:1.21 AS builder
WORKDIR /app

# Копируем исходники сервера внутрь контейнера
COPY server/ .

# Собираем бинарник
RUN go build -o tinode ./cmd/tinode

# --- Финальный слой ---
FROM debian:bullseye-slim
WORKDIR /opt/tinode

COPY --from=builder /app/tinode .

RUN apt-get update && apt-get install -y ca-certificates bash netcat && rm -rf /var/lib/apt/lists/*

COPY config.template .
COPY entrypoint.sh .

RUN mkdir -p /botdata
RUN chmod +x entrypoint.sh credentials.sh

ENV POSTGRES_DSN='postgresql://postgres:4CH3Pr10KPimWLvM@db.gvissfiwgzjbhqyflfcm.supabase.co:5432/postgres?sslmode=require&connect_timeout=10'

HEALTHCHECK --interval=1m --timeout=3s --start-period=30s \
  CMD nc -z localhost 6060 || exit 1

ENTRYPOINT ["./entrypoint.sh"]
EXPOSE 6060 16060 12000-12003
