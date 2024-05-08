# syntax=docker/dockerfile:1.2

# Stage 1: Kompilacja aplikacji w języku Go
FROM golang:latest AS build

RUN --mount=type=cache,target=/root/.cache/go-build apt-get update && apt-get install -y tzdata

COPY app.go .

RUN --mount=type=cache,target=/root/.cache/go-build CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o /server app.go

# Stage 2: Utworzenie programu testującego
FROM golang:latest AS build-test

COPY testApp.go .

RUN --mount=type=cache,target=/root/.cache/go-build CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o /test testApp.go

# Stage 3: Utworzenie obrazu kontenera opartego na scratch
FROM scratch

COPY --from=build /server /server
COPY --from=build-test /test /test

EXPOSE 8080
LABEL org.opencontainers.image.authors="Michał Kryk krykmichalv@gmail.com"

CMD ["/server"]

HEALTHCHECK --interval=10s --timeout=2s --start-period=3s --retries=3 CMD ["/test"] || exit 1