#!/bin/bash -x
if [ "$1" = "run" ]; then

    echo "${efs_ip}:/ /mnt/efs nfs4 nofail,rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,hard,noresvport,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=${onion_ip},local_lock=none,addr=${efs_ip} 0 0" |tee -a /etc/fstab
    mount -a
    chgrp ubuntu /mnt/efs/
    chmod g+w /mnt/efs/
    logger "THE END"

fi