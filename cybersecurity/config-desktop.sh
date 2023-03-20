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
  apt-get -o DPkg::Options::=--force-confdef install -y xfce4 xfce4-goodies ostinato filezilla thunderbird git build-essential netfilter-persistent iptables-persistent chromium-browser filezilla xrdp gkrellm
  adduser xrdp ssl-cert
  iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
  iptables -t nat -A PREROUTING -i ens5 -p tcp -m multiport --dports 80,443 -j DNAT --to-destination 10.0.1.11
  netfilter-persistent save
  echo xfce4-session > /home/ubuntu/.xsession
  chown ubuntu:ubuntu /home/ubuntu/.xsession
  systemctl enable --now xrdp

  apt-get -y install mono-devel
  wget https://www.netresec.com/?download=NetworkMiner -O /tmp/nm.zip
  unzip /tmp/nm.zip -d /opt/
  cd /opt/NetworkMiner* || exit
  sudo chmod +x NetworkMiner.exe
  sudo chmod -R go+w AssembledFiles/
  sudo chmod -R go+w Captures/

  echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
  sudo DEBIAN_FRONTEND=noninteractive apt-get -y  install wireshark qt5-image-formats-plugins qtwayland5 snmp-mibs-downloader geoipupdate geoip-database libjs-leaflet libjs-leaflet.markercluster wireshark-doc

  echo "#!/usr/bin/env bash" > /home/ubuntu/Desktop/NetworkMiner.sh
  echo "mono /opt/NetworkMiner*/NetworkMiner.exe" >> /home/ubuntu/Desktop/NetworkMiner.sh
  chown ubuntu:ubuntu /home/ubuntu/Desktop/NetworkMiner.sh
  chmod ug+x /home/ubuntu/Desktop/NetworkMiner.sh

  shutdown -hr 1
fi
