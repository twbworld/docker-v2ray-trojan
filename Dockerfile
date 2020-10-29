FROM ubuntu:20.04

LABEL maintainer="twb<1174865138@qq.com><github.com/twbworld>"
LABEL description="构建v2ray-trojan镜像"

ARG VLESS_SH=https://raw.githubusercontent.com/wulabing/V2Ray_ws-tls_bash_onekey/dev/install.sh
ARG VMESS_SH=https://git.io/v2ray.sh
ARG TROJAN_SH=https://raw.githubusercontent.com/atrandys/trojan/master/trojan_mult.sh

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
          cron \
        && cd /root \
        && wget -N --no-check-certificate -q -O install_v2ray_vless.sh "${VLESS_SH}" \
        && wget -N --no-check-certificate -q -O install_v2ray_vmess.sh "${VMESS_SH}" \
        && wget -N --no-check-certificate -q -O install_trojan.sh "${TROJAN_SH}" \
        && chmod +x install_v2ray_vless.sh \
        && chmod +x install_v2ray_vmess.sh \
        && chmod +x install_trojan.sh
