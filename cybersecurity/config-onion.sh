#!/bin/bash -x
if [ "$1" = "run" ]; then

  LOGFILE="/var/log/cloud-config-"$(date +%s)
  SCRIPT_LOG_DETAIL="$LOGFILE"_$(basename "$0").log

  # Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>$SCRIPT_LOG_DETAIL 2>&1

  hostnamectl set-hostname onion

  # Debconf needs to be told to accept that user interaction is not desired
  export DEBIAN_FRONTEND=noninteractive
  export DEBCONF_NONINTERACTIVE_SEEN=true
  apt-get -o DPkg::Options::=--force-confdef update
  apt-get -y -o DPkg::Options::=--force-confdef upgrade
  apt-get -o DPkg::Options::=--force-confdef install -y git build-essential curl ethtool chromium-browser network-manager nfs-common xrdp filezilla
  adduser xrdp ssl-cert
  systemctl enable --now xrdp

  #apt install -y xfce4 xfce4-goodies
  #echo xfce4-session > /home/ubuntu/.xsession
  #chown ubuntu:ubuntu /home/ubuntu/.xsession

  mv /etc/netplan/50-cloud-init.yaml /etc/netplan/01-network-manager-all.yaml
  sudo touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
  patch /etc/netplan/01-network-manager-all.yaml < /var/lib/cloud/instance/scripts/50-cloud-init.yaml.patch
  systemctl enable --now NetworkManager
  netplan apply
  mkdir /mnt/efs
  /var/lib/cloud/instance/scripts/update-fstab.sh
  mount -a
  chgrp ubuntu /mnt/efs/
  chmod g+w /mnt/efs/

#  rmdir /opt
#  mkdir /mnt/efs/opt
#  ln -s /mnt/efs/opt /opt
#  mkdir /mnt/efs/nsm
#  ln -s /mnt/efs/nsm /nsm
#  mkdir /mnt/efs/docker
#  ln -s /mnt/efs/docker /var/lib/docker

  fallocate -l 8G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

  shutdown -hr 1
fi
