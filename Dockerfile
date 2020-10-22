FROM ubuntu:20.04

LABEL maintainer="twb<1174865138@qq.com><github.com/twbworld>"
LABEL description="构建ubuntu-v2ray镜像"

ARG VLESS_SH=https://raw.githubusercontent.com/wulabing/V2Ray_ws-tls_bash_onekey/dev/install.sh
ARG VMESS_SH=https://git.io/v2ray.sh

WORKDIR /root

RUN set -xe \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
          curl \
          wget \
          vim \
          git \
          init \
          systemd \
          openssl \
          ca-certificates \
        && cd /root \
        && wget -N --no-check-certificate -q -O install_v2ray_vless.sh "${VLESS_SH}" \
        && wget -N --no-check-certificate -q -O install_v2ray_vmess.sh "${VMESS_SH}" \
        && chmod +x install_v2ray_vless.sh \
        && chmod +x install_v2ray_vmess.sh
