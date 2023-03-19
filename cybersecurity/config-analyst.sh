#!/bin/bash -x
  if [ "$1" = "run" ]; then
  LOGFILE="/var/log/cloud-config-"$(date +%s)
  SCRIPT_LOG_DETAIL="$LOGFILE"_$(basename "$0").log

  # Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>$SCRIPT_LOG_DETAIL 2>&1

  hostnamectl set-hostname analyst
  yum -y update
  yum -y group install 'Development Tools'

fi
