# ==============================================================================
# ETAPA 1: Compilacion de Packwiz desde el codigo fuente oficial en Go
# ==============================================================================
FROM golang:alpine AS builder

# Compila e instala la ultima version de packwiz en /go/bin/packwiz
RUN go install github.com/packwiz/packwiz@latest

# ==============================================================================
# ETAPA 2: Imagen final ultraligera (solo contiene el binario compilado)
# ==============================================================================
FROM alpine:3.21

# Instalamos certificados SSL (obligatorios para conectar por HTTPS a Modrinth)
# y git (util para operaciones internas de packwiz)
RUN apk --no-cache add ca-certificates git

# Copiamos UNICAMENTE el ejecutable compilado desde la Etapa 1
COPY --from=builder /go/bin/packwiz /usr/local/bin/packwiz

# Evitamos ejecutar como root creando un usuario estandar (UID/GID 1000)
RUN adduser -D -u 1000 packwizuser
USER packwizuser

# Carpeta interna donde montaremos nuestro proyecto de Windows
WORKDIR /workspace

# Convertimos el contenedor en el comando 'packwiz' directamente
ENTRYPOINT ["packwiz"]