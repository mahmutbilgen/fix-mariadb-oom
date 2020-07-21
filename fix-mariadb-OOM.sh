#!/bin/bash
# version=1.0
# cheking Maria DB OOM and restart service
#
# grep -ri ^$todaydate  /var/log/mariadb/mariadb.log | grep -iq "out of memory" ; echo $?
#
#
todaydate=$(date +%y%m%d)
#todaydate=200515

if  grep -ri ^$todaydate /var/log/mariadb/mariadb.log | grep -iq "Out of memory"  ;then
   systemctl restart mariadb
   echo "$todaydate: INFO : Maria DB restarted "
else 
   echo "$todaydate: INFO : Maria DB is healthy no OOM  "
fi
