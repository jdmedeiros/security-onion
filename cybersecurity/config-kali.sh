#!/bin/bash -x
  if [ "$1" = "run" ]; then
  LOGFILE="/var/log/cloud-config-"$(date +%s)
  SCRIPT_LOG_DETAIL="$LOGFILE"_$(basename "$0").log

  # Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>$SCRIPT_LOG_DETAIL 2>&1

  hostnamectl set-hostname kali
  export DEBIAN_FRONTEND=noninteractive
  export DEBCONF_NONINTERACTIVE_SEEN=true
  apt-get -o DPkg::Options::=--force-confdef update
  apt-get -y -o DPkg::Options::=--force-confdef upgrade

  apt-get -y install mono-devel
  wget https://www.netresec.com/?download=NetworkMiner -O /tmp/nm.zip
  unzip /tmp/nm.zip -d /opt/
  mv /opt/NetworkMiner* /opt/NetworkMiner
  cd /opt/NetworkMiner || exit
  sudo chmod +x NetworkMiner.exe
  sudo chmod -R go+w AssembledFiles/
  sudo chmod -R go+w Captures/

  cp /var/lib/cloud/instance/scripts/NetworkMiner.desktop /usr/share/applications/NetworkMiner.desktop
  chmod ugo+x /usr/share/applications/NetworkMiner.desktop
  cp /var/lib/cloud/instance/scripts/45-allow-colord.pkla /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla

  reboot
fi
