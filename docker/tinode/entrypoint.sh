#!/bin/sh

# --- Создаем временный файл ключа Firebase (если задана переменная окружения) ---
if [ -n "$FCM_SERVICE_ACCOUNT_JSON" ]; then
  echo "🔹 Подготовка firebase-key.json..."
  echo "$FCM_SERVICE_ACCOUNT_JSON" > ./firebase-key.json
fi

# --- Проверяем JWT_SECRET ---
if [ -z "$JWT_SECRET" ]; then
  echo "⚠️ JWT_SECRET не задан! Используется временный небезопасный ключ."
  export JWT_SECRET="default_secret_change_me"
fi

# --- Инициализация базы данных ---
echo "🔹 Инициализация базы..."
./init-db -config=./tinode.conf -data=./data/

# --- Запуск сервера Tinode ---
echo "🔹 Запуск Tinode на порту 6060..."
exec ./tinode-server -config=./tinode.conf
