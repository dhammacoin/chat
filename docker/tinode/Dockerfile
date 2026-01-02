# Dockerfile для Tinode Chat Server
# Скопировано и адаптировано из официального репозитория Tinode

FROM alpine:3.22

ARG VERSION=0.25
ENV VERSION=$VERSION
ARG BINVERS=$VERSION

LABEL maintainer="Tinode Team <info@tinode.co>"
LABEL name="TinodeChatServer"
LABEL version=$VERSION

# Database selector для PostgreSQL
ARG TARGET_DB=postgres
ENV TARGET_DB=$TARGET_DB

# Runtime options
ENV WAIT_FOR=
ENV RESET_DB=false
ENV UPGRADE_DB=false
ENV NO_DB_INIT=false
ENV SAMPLE_DATA=data.json
ENV DEFAULT_COUNTRY_CODE=US

# PostgreSQL DSN (Supabase)
ENV POSTGRES_DSN='postgresql://postgres:postgres@localhost:5432/tinode?sslmode=disable&connect_timeout=10'

# Chatbot plugin
ENV PLUGIN_PYTHON_CHAT_BOT_ENABLED=false

# Media handler
ENV MEDIA_HANDLER=fs
ENV FS_CORS_ORIGINS='["*"]'

# Email settings
ENV SMTP_HOST_URL='http://localhost:6060'
ENV SMTP_SERVER=
ENV SMTP_PORT=
ENV SMTP_SENDER=
ENV SMTP_LOGIN=
ENV SMTP_PASSWORD=
ENV SMTP_AUTH_MECHANISM=
ENV SMTP_HELO_HOST=
ENV EMAIL_VERIFICATION_REQUIRED=
ENV DEBUG_EMAIL_VERIFICATION_CODE=
ENV SMTP_DOMAINS=''

# Encryption keys (замени на свои в продакшене!)
ENV API_KEY_SALT=T713/rYYgW7g4m3vG6zGRh7+FM1t0T8j13koXScOAj4=
ENV AUTH_TOKEN_KEY=wfaY2RgF2S1OQI/ZlK+LSrp1KB2jwAdGAIHQ7JZn+Kc=
ENV UID_ENCRYPTION_KEY=la6YsO+bNX/+XIkOqc5Svw==

# TLS (disabled by default)
ENV TLS_ENABLED=false
ENV TLS_DOMAIN_NAME=
ENV TLS_CONTACT_ADDRESS=

# Push notifications
ENV FCM_PUSH_ENABLED=false
ENV FCM_API_KEY=
ENV FCM_APP_ID=
ENV FCM_SENDER_ID=
ENV FCM_PROJECT_ID=
ENV FCM_VAPID_KEY=
ENV FCM_MEASUREMENT_ID=
ENV FCM_INCLUDE_ANDROID_NOTIFICATION=true

# Tinode Push Gateway
ENV TNPG_PUSH_ENABLED=false
ENV TNPG_AUTH_TOKEN=
ENV TNPG_ORG=

# WebRTC
ENV WEBRTC_ENABLED=false
ENV ICE_SERVERS_FILE=

# Storage adapter
ENV STORE_USE_ADAPTER=$TARGET_DB

# Server status path
ENV SERVER_STATUS_PATH=''

# Account garbage collection
ENV ACC_GC_ENABLED=false

# Install dependencies
RUN apk update && \
	apk add --no-cache ca-certificates bash grep

WORKDIR /opt/tinode

# Copy config template and entrypoint
COPY config.template .
COPY entrypoint.sh .

# Download Tinode build для PostgreSQL
ADD https://github.com/tinode/chat/releases/download/v$BINVERS/tinode-$TARGET_DB.linux-amd64.tar.gz .

# Unpack archive
RUN tar -xzf tinode-$TARGET_DB.linux-amd64.tar.gz && \
	rm tinode-$TARGET_DB.linux-amd64.tar.gz

# Create directory for chatbot data
RUN mkdir -p /botdata

# Make scripts executable
RUN chmod +x entrypoint.sh && \
	chmod +x credentials.sh

# Healthcheck
HEALTHCHECK --interval=1m --timeout=3s --start-period=30s \
  CMD nc -z localhost 6060 || exit 1

# Generate config and run server
ENTRYPOINT ["./entrypoint.sh"]

# HTTP, gRPC, cluster ports
EXPOSE 6060 16060 12000-12003
