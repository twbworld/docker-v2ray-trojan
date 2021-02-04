
**docker-v2ray-trojan**
===========

[![](https://img.shields.io/badge/docker-v2ray%2d-trojan-099cec?logo=docker)](https://hub.docker.com/r/twbworld/v2ray-trojan)


# 构建镜像
``` sh
docker build -f Dockerfile -t twbworld/v2ray-trojan:latest .
```


# Docker使用
> 本镜像只提供运行所需的环境, 安装 `V2Ray` 或 `Trojan` 自行进入容器执行脚本

``` sh
docker run --privileged -itd --restart=always --name v2ray-trojan --hostname docker-v2ray-trojan -v /etc/localtime:/etc/localtime:ro -p 80:80 -p 443:443 twbworld/v2ray-trojan:latest /sbin/init

docker exec -it v2ray-trojan /bin/bash

bash install.sh
```


# 安装种类

##  V2Ray-VLess(推荐)
  * 推荐,需准备域名,并解析

## V2Ray-VMess
  * 不建议, 被查封概率大

## Trojan
  * 需准备域名,并解析
  * 不支持cdn代理

## Trojan-Go(推荐)
  * 需准备域名,并解析,需要连接到mysql
  * 可能需要由 `trojan` , 切换到 `trojan-go`; 如果安装完后, trojan没有启动,请执行 `更新trojan`
  * `trojan-go` 如需开启 `websocket` 和 `多路复用` (如需开启BBR加速, 请见下文), 文件 `/usr/local/etc/trojan/config.json` 结尾加入以下代码,注意json格式
   ``` sh
      "websocket": {
          "enabled": true,
          "path": "/trojan-go-ws/",
          "host": "demain.com"
      },
      "mux": {
          "enabled": true,
          "concurrency": 8,
          "idle_timeout": 60
      }
   ```
  * (不必须)如使用cdn,为了保护隐私(trojan和vless都不自带加密),开启shadowsocks AEAD二次加密  
  文件 `/usr/local/etc/trojan/config.json` 结尾加入以下代码,注意json格式
  ``` sh
      "shadowsocks": {
          "enabled": true,
          "password": "your_password",
          "method": "AES-128-GCM"
      }
  ```



# 提示
* 注意,如使用TLS则需要监听80端口用于验证域名证书,,如果宿主机或其他容器也监听了80端口,这就会产生端口冲突;建议利用宿主机的Nginx(或Nginx容器)反向代理功能 把80端口代理到 V2Ray容器内的Nginx,例(VLess) :
  ``` sh
    # Nginx配置
    server {
        listen 80;
        listen [::]:80;
        server_name domain.com;
        root /usr/share/nginx/;
        location /
        {
            proxy_pass http://vless:80; #代理到V2Ray容器内的Nginx, "vless"为docker的容器名称
            proxy_http_version 1.1;
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            add_header X-Slave $upstream_addr;
        }
    }

    # 如果使用的是Nginx容器,还需要跟V2Ray容器使用同一个网桥, 例 :
    docker run --privileged -itd --restart=always --name v2ray-trojan --hostname docker-v2ray-trojan -v /etc/localtime:/etc/localtime:ro -p 80:80 -p 443:443 --network my_net --ip x.x.x.x twbworld/v2ray-trojan:latest /sbin/init
  ```
* 注意: Trojan需要占用443端口,如果为了共用443端口,而通过正常的Nginx反向代理是不行的(因为Trojan比Nginx还"前"),需要配置Nginx的stream模块实现

* linux内核版本 > 4.9已自带BBR; 如需BBR, 可选择安装 , 一般选择 `BBRplus版`
* 可使用 `Cloudflare` 的免费cdn隐藏vps的ip, 缺点是可能对速度影响较大, 其次vless协议和trojan协议自身不带加密的,对于cdn来说是明文(解决: 使用shadowsocks AEAD二次加密)
* 如果您决定使用 `Cloudflare` 的cdn,请悉知并修改为其允许代理的端口(如80/443/2053/2083): <https://support.cloudflare.com/hc/zh-cn/articles/200169156>
* `Cloudflare` 配置cdn :
  1. 把您的域名的默认dns服务器地址改为 `Cloudflare` 的dns服务器地址
  2. 搭建完 `v2ray` 或 `trojan-go` 后, 在 `Cloudflare` 下配置域名被 `Cloudflare` 的cdn所代理(`云朵`图标变为橙色)
  3. `SSL/TLS` 菜单下, 设置 `加密模式` 为 `完全`
  4. (可选) `防火墙` 菜单下, `防火墙规则` 和 `工具` 设置地区白名单



# 连接
| 客户端 | 种类 | 平台 |
| ---- | ---- | ---- |
| v2rayN | vless / vmess / trojan | Windows |
| v2rayNG | vless / vmess / trojan | Android |
| Qv2ray | vless / vmess / trojan / trojan-go | Windows |
| igniter | trojan / trojan-go | Android |
