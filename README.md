# docker-sjx

实践星Dockerfile

## 构建镜像

`docker build -t fifilyu/sjx:0.0.1 .`

## 创建容器

```bash
docker run -d --privileged \
    -p 2022:22 \
    -p 2080:8080 \
    --env LANG=en_US.UTF-8 \
    --env TZ=Asia/Shanghai \
    --name sjx geekcamp/sjx:v1
```
