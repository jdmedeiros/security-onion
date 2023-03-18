#!/bin/bash -x
  if [ "$1" = "run" ]; then
  LOGFILE="/var/log/cloud-config-"$(date +%s)
  SCRIPT_LOG_DETAIL="$LOGFILE"_$(basename "$0").log

  # Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>$SCRIPT_LOG_DETAIL 2>&1

  hostnamectl set-hostname desktop

  sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
  sysctl -p

  # Debconf needs to be told to accept that user interaction is not desired
  export DEBIAN_FRONTEND=noninteractive
  export DEBCONF_NONINTERACTIVE_SEEN=true
  apt-get -o DPkg::Options::=--force-confdef update
  apt-get -y -o DPkg::Options::=--force-confdef upgrade
  apt-get -o DPkg::Options::=--force-confdef install -y xfce4 xfce4-goodies filezilla thunderbird git build-essential netfilter-persistent iptables-persistent chromium-browser filezilla xrdp gkrellm
  adduser xrdp ssl-cert
  iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
  iptables -t nat -A PREROUTING -i ens5 -p tcp -m multiport --dports 80,443 -j DNAT --to-destination 10.0.1.11
  netfilter-persistent save
  echo xfce4-session > /home/ubuntu/.xsession
  chown ubuntu:ubuntu /home/ubuntu/.xsession
  systemctl enable --now xrdp

fi
