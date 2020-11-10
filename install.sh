#!/bin/bash

trojanGoSh=https://git.io/trojan-install
trojanSh=https://raw.githubusercontent.com/atrandys/trojan/master/trojan_mult.sh
bbrSh=https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh
vlessSh=https://raw.githubusercontent.com/wulabing/V2Ray_ws-tls_bash_onekey/dev/install.sh
vmessSh=https://git.io/v2ray.sh

blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}


if [[ -f /etc/redhat-release ]]; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
fi

change_panel(){
if test -s /etc/systemd/system/trojan-web.service; then
    green " "
    green " "
    green "================================="
     blue "  检测到Trojan面板服务，开始配置"
    green "================================="
    sleep 2s
    $systemPackage update -y
    $systemPackage -y install nginx unzip curl wget
    systemctl enable nginx
    systemctl stop nginx
if test -s /etc/nginx/nginx.conf; then
    rm -rf /etc/nginx/nginx.conf
  wget -P /etc/nginx https://raw.githubusercontent.com/V2RaySSR/Trojan_panel_web/master/nginx.conf
    green "================================="
    blue "     请输入Trojan绑定的域名"
    green "================================="
    read your_domain
  sed -i "s/localhost/$your_domain/;" /etc/nginx/nginx.conf
    green "================================="
    blue "     请输入Trojan绑定的域名所使用的端口 (端口用于管理面板, 请为端口开放防火墙策略)"
    green "================================="
    read web_port
    green " "
    green "================================="
     blue "    开始下载伪装站点源码并部署"
    green "================================="
    sleep 2s
    rm -rf /usr/share/nginx/html/*
    cd /usr/share/nginx/html/
    wget https://github.com/V2RaySSR/Trojan/raw/master/web.zip
    unzip web.zip
    green " "
    green "================================="
    blue "       配置trojan-web"
    green "================================="
    sleep 2s
  sed -i "/ExecStart/s/trojan web -p $web_port/trojan web/g" /etc/systemd/system/trojan-web.service
  sed -i "/ExecStart/s/trojan web/trojan web -p $web_port/g" /etc/systemd/system/trojan-web.service
  systemctl daemon-reload
  systemctl restart trojan-web
  systemctl restart nginx
  green " "
  green " "
  green " "
    green "==========================完成========================================"
     blue "  伪装站点目录 /usr/share/nginx/html "
     blue "  面板管理地址 http://$your_domain:$web_port "
     blue "  伪装站点 https://$your_domain "
    green "=================================================================="
else
    green "==============================="
      red "     Nginx未正确安装 请重试"
    green "==============================="
    sleep 2s
    exit 1
fi
else
    green "==============================="
      red "    未检测到Trojan面板服务"
    green "==============================="
    sleep 2s
    exit 1
fi
}

bbr_boost_sh(){
    $systemPackage install -y wget
    wget -N --no-check-certificate -q -O install_bbr.sh "$bbrSh" && chmod +x install_bbr.sh && bash install_bbr.sh
}

trojan_go_install(){
  $systemPackage install -y wget
  wget -N --no-check-certificate -q -O install_trojan_go.sh "$trojanGoSh" && chmod +x install_trojan_go.sh && bash install_trojan_go.sh
}

trojan_install(){
  $systemPackage install -y wget
  wget -N --no-check-certificate -q -O install_trojan.sh "$trojanSh" && chmod +x install_trojan.sh && bash install_trojan.sh
}

vless_install(){
  $systemPackage install -y wget
  wget -N --no-check-certificate -q -O install_v2ray_vless.sh "$vlessSh" && chmod +x install_v2ray_vless.sh && bash install_v2ray_vless.sh
}

vmess_install(){
  $systemPackage install -y wget
  wget -N --no-check-certificate -q -O install_v2ray_vmess.sh "$vmessSh" && chmod +x install_v2ray_vmess.sh && bash install_v2ray_vmess.sh
}

start_menu(){
  clear
    green "=========================================================="
   blue " 建议Docker容器内操作"
   blue " 基于波仔(www.v2rayssr.com)和Jrohy等脚本的整合"
    green "========================Trojan-Go=================================="
     blue " 1. 安装Jrohy大神的trojan-go面板程序"
   blue " 2. 更改web面板端口并设置伪装站点(注: 必须先安装步骤1的trojan-go面板程序)"
    green "========================Trojan=================================="
     blue " 3. 安装Trojan程序(包含安装BBR程序)"
    green "========================V2ray-VLess=================================="
     blue " 4. 安装Vless程序(自动安装BBR)"
    green "========================V2ray-VMess=================================="
     blue " 5. 安装Vmess程序"
    green "===========================BBR加速====================================="
   blue " 6. 安装 BBRPlus4 合一加速"
    green "==================================================================="
   blue " 0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
        trojan_go_install
        ;;
        2)
        change_panel
        ;;
        3)
        trojan_install
        ;;
        4)
        vless_install
        ;;
        5)
        vmess_install
        ;;
        6)
        bbr_boost_sh
        ;;
        0)
        exit 0
        ;;
        *)
    clear
    echo "请输入正确数字"
    sleep 2s
    start_menu
    ;;
    esac
}

start_menu