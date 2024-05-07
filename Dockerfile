# syntax=docker/dockerfile:1.2

# Stage 1: Kompilacja aplikacji w języku Go
FROM golang:latest AS build

RUN --mount=type=cache,target=/root/.cache/go-build apt-get update && apt-get install -y tzdata

COPY app.go .

RUN --mount=type=cache,target=/root/.cache/go-build CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o /server app.go

# Stage 2: Utworzenie obrazu kontenera opartego na scratch
FROM scratch

ADD alpine-minirootfs-3.19.1-x86_64.tar /

COPY --from=build /server /server

EXPOSE 8080
LABEL org.opencontainers.image.authors="Michał Kryk krykmichalv@gmail.com"

CMD ["/server"]

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD [ "wget", "-q", "-O", "-", "http://localhost:8080" ] || exit 1