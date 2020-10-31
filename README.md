
**docker-v2ray-trojan**
===========

[![](https://img.shields.io/badge/docker-v2ray_trojan-099cec?logo=docker)](https://hub.docker.com/r/twbworld/v2ray-trojan)


# 构建镜像
例 :
```shell
docker build -f Dockerfile -t twbworld/v2ray-trojan:latest .
```
# 安装种类

## V2Ray-VLess (推荐,需准备域名,并解析)

```shell
    # 80端口用于证书验证,443是v2ray端口
    docker run --privileged -itd --restart=always --name vless -v /etc/localtime:/etc/localtime:ro -p 80:80 -p 443:443 twbworld/v2ray-trojan:latest /sbin/init

    docker exec -it vless /bin/bash

    bash install_v2ray_vless.sh
```

## V2Ray-VMess
```shell
    docker run --privileged -itd --restart=always --name vmess -v /etc/localtime:/etc/localtime:ro -p 12345:12345 twbworld/v2ray-trojan:latest /sbin/init

    docker exec -it vmess /bin/bash

    bash install_v2ray_vmess.sh
```

## trojan (需准备域名,并解析)
```shell
    docker run --privileged -itd --restart=always --name trojan -v /etc/localtime:/etc/localtime:ro -p 80:80 -p 443:443 twbworld/v2ray-trojan:latest /sbin/init

    docker exec -it trojan /bin/bash

    bash install_trojan.sh
```

> PS: trojan不支持cdn代理

## trojan-go (推荐,需准备域名,并解析,需要连接到mysql)
```shell
    docker run --privileged -itd --restart=always --name trojan-go -v /etc/localtime:/etc/localtime:ro -p 80:80 -p 443:443 twbworld/v2ray-trojan:latest /sbin/init

    docker exec -it trojan-go /bin/bash

    bash install_trojan_go.sh
```

> 脚本默认的是 `trojan` , 需要切换到 `trojan-go`  
> 
> `trojan-go` 如需开启 `websocket` 和 `多路复用` (如需开启BBR加速, 请见下文), 文件 `/usr/local/etc/trojan/config.json` 结尾加入以下代码,注意json格式
> ```
    "websocket": {
        "enabled": true,
        "path": "/trojan-go-ws/",
        "host": "你的域名"
    },
    "mux": {
        "enabled": true,
        "concurrency": 8,
        "idle_timeout": 60
    }
> ```

> (不使用cdn,不必须)开启shadowsocks AEAD二次加密  
> 文件 `/usr/local/etc/trojan/config.json` 结尾加入以下代码,注意json格式
> ```
    "shadowsocks": {
        "enabled": true,
        "password": "你的密码",
        "method": "AES-128-GCM"
    }
> ```



# 提示
> 除了 `V2Ray-VMess` 外的三种方式,需要安装Nginx并监听80端口,如果宿主机Nginx(或Nginx容器)也监听了80端口,这就会产生端口冲突;建议利用宿主机的Nginx(或Nginx容器)反向代理功能 把80端口代理到 V2Ray容器内的Nginx,例(VLess) :
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
>    docker run --privileged -itd --restart=always --name vless --network my_net --ip x.x.x.x -v /etc/localtime:/etc/localtime:ro -p 80:80 -p 443:443 twbworld/v2ray-trojan:latest /sbin/init
>  ```

> `install_trojan_go.sh` 和 `install_trojan.sh` 都不带 `BBR` 加速, 如需BBR, 请执行 `install_bbr.sh` ; 一般选择 `BBRplus版` 的BBR

> 可使用 `Cloudflare` 的免费cdn隐藏vps的ip, 缺点是可能对速度影响较大, 其次vless和trojan自身不带加密,对于cdn来说是明文(解决: 使用shadowsocks AEAD二次加密)
> 如果您决定使用 `Cloudflare` 的cdn,请悉知并修改为其允许代理的端口: <https://support.cloudflare.com/hc/zh-cn/articles/200169156>  
> `Cloudflare` 配置cdn :
> 1. 把您的域名的默认dns服务器地址改为 `Cloudflare` 的dns服务器地址
> 2. 搭建完 `v2ray` 后, 在 `Cloudflare` 下配置域名被 `Cloudflare` 的cdn所代理(`云朵`图标变为橙色)
> 3. `SSL/TLS` 菜单下, 设置 `加密模式` 为 `完全`
> 4. (可选) `防火墙` 菜单下, `防火墙规则` 和 `工具` 设置地区白名单



# 连接
| 客户端 | 种类 | 平台 |
| ---- | ---- | ---- |
| v2rayN | vless / vmess / trojan | Windows |
| v2rayNG | vless / vmess / trojan | Android |
| Qv2ray | vless / vmess / trojan / trojan-go | Windows |
| igniter | trojan / trojan-go | Android |
