# Compilamos packwiz a partir de su código fuente oficial en Go.
FROM golang:alpine AS builder

RUN go install github.com/packwiz/packwiz@latest


FROM alpine:3.21

# Certificados para conexiones HTTPS y git para las operaciones de packwiz.
RUN apk --no-cache add ca-certificates git

COPY --from=builder /go/bin/packwiz /usr/local/bin/packwiz

# Ejecutamos el contenedor con un usuario sin privilegios de root.
RUN adduser -D -u 1000 packwizuser
USER packwizuser

# Directorio donde se montará el proyecto.
WORKDIR /workspace

ENTRYPOINT ["packwiz"]