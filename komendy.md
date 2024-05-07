docker build -t local/server-image . && docker run --rm -it -p 8080:8080 --name Test1 local/server-image /server

Budowanie obrazu
docker build -t local/server-image .

Uzyskania informacji, które wygenerował serwer w trakcie uruchamiana kontenera
docker run --rm -p 8080:8080 --name Test1 local/server-image

Sprawdzenie warstw obrazu
docker history local/server-image

docker buildx build --platform linux/amd64,linux/arm64 --cache-from=type=registry,ref=local/server-image:latest --cache-to=type=registry,ref=local/server-image:cache --push -t local/server-image:latest .

docker buildx build --platform linux/amd64,linux/arm64 --cache-from=type=registry,ref=maxenv/lab7:cache --cache-to=type=registry,ref=maxenv/lab7:cache,mode=max --push -t docker.io/maxenv/lab7:czw2 .
