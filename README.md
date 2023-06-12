#### postgresql-docker

```shell
docker build . -f Dockerfile -t postgresql
```

```shell
docker run --rm -d -u postgres -p 5432:5432 postgresql
``` 

```shell
export POSTGRESQL_SERVER_IP=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgresql`
```
