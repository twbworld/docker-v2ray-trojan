
**docker-v2ray-trojan**
===========

[![](https://img.shields.io/badge/docker-v2ray_trojan-099cec?logo=docker)](https://hub.docker.com/r/twbworld/v2ray-trojan)


# 构建镜像
例 :
```shell
docker build -f Dockerfile -t twbworld/v2ray-trojan:latest .
```
# 安装种类

## V2Ray(两种协议)
* **VLess** (推荐,需准备域名,并解析)
```shell
    # 80端口用于证书验证,443是v2ray端口
    docker run --privileged -itd --name vless -v /etc/localtime:/etc/localtime:ro -p 80:80 -p 443:443 twbworld/v2ray-trojan:latest /sbin/init

    docker exec -it vless /bin/bash

    bash install_v2ray_vless.sh
```
> VMess的脚本需要安装Nginx并监听80端口,如果宿主机Nginx(或Nginx容器)也监听了80端口,这就会产生端口冲突;建议利用宿主机的Nginx(或Nginx容器)反向代理功能 把80端口代理到 V2Ray容器内的Nginx,例 :
>  ```shell
>    # Nginx配置
>    server {
>        listen 80;
>        listen [::]:80;
>        server_name domain.com;
>        root /usr/share/nginx/;
>        location /
>        {
>            proxy_pass http://vless:80; #代理到V2Ray容器内的Nginx, "vless"为docker的容器名称
>            proxy_http_version 1.1;
>            proxy_set_header Host $http_host;
>            proxy_set_header X-Real-IP $remote_addr;
>            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
>            add_header X-Slave $upstream_addr;
>        }
>    }
>
>    # 如果使用的是Nginx容器,还需要跟V2Ray容器使用同一个网桥, 例 :
>    docker run --privileged -itd --name V2Ray --network my_net --ip x.x.x.x -v /etc/localtime:/etc/localtime:ro >-p 80:80 -p 443:443 twbworld/v2ray-trojan:latest /sbin/init
>  ```

* **VMess**
```shell
    docker run --privileged -itd --name vmess -v /etc/localtime:/etc/localtime:ro -p 12345:12345 twbworld/v2ray-trojan:latest /sbin/init

    docker exec -it vmess /bin/bash

    bash install_v2ray_vmess.sh
```

## trojan (需准备域名,并解析)
```shell
    docker run --privileged -itd --name trojan -v /etc/localtime:/etc/localtime:ro twbworld/v2ray-trojan:latest /sbin/init

    docker exec -it trojan /bin/bash

    bash install_trojan.sh
```


> 可使用 `Cloudflare` 的免费cdn隐藏vps的ip, 缺点是对速度影响较大  
> 如果您决定使用 `Cloudflare` 的cdn,请悉知并修改为其允许代理的端口: <https://support.cloudflare.com/hc/zh-cn/articles/200169156>  
> `Cloudflare` 配置cdn :
> 1. 把您的域名的默认dns服务器地址改为 `Cloudflare` 的dns服务器地址
> 2. 搭建完 `v2ray` 后, 在 `Cloudflare` 下配置域名被 `Cloudflare` 的cdn所代理(`云朵`图标变为橙色)
> 3. `SSL/TLS` 菜单下, 设置 `加密模式` 为 `完全`
> 4. (可选) `防火墙` 菜单下, `防火墙规则` 和 `工具` 设置地区白名单



# 连接
| 平台 | 客户端 |
| ---- | ---- |
| Windows | v2rayN |
| MacOS | V2RayU / V2RayX |
| Android | v2rayNG |
| IOS | Shadowrocket |