#!/bin/bash
# version=1.1
# cheking Maria DB OOM and restart service
#
# 2020-07-19 1.1 MB: added more control
# 2020-06-06 1.0 MB: initial version
#
todaydate=$(date +%y%m%d_%H:%M)
today=$(date +%y%m%d)
#todaydate=200515
LOGFILE="/var/log/mariadb/mariadb.log"
basedir=/root/fix-mariadb-oom
LAZY_FILE="$basedir/conf/lazy_file"

time_error=$(grep -i "Out of memory" $LOGFILE | tail -1 | cut -f1-2 -d\ | sed -e 's/ //' | cut -f1-2 -d:| sed -e 's/://' )
echo $time_error

time_current=$(date +%y%m%d%H%M) ; echo $time_current ;
time_gap=$(expr $time_current - $time_error) ; echo $time_gap

if [ $time_gap -lt 50 ] ; then
   if [ ! -f $LAZY_FILE ] ;then
      systemctl restart mariadb
      echo "$todaydate: INFO : Maria DB restarted "     
      touch $LAZY_FILE
   fi
else 
   if [ -f $LAZY_FILE ] ; then
      rm $LAZY_FILE
      echo "$todaydate: INFO : Lazy file removed   "
   fi      
   echo "$todaydate: INFO : Maria DB is healthy no OOM  "
fi

