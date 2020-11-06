#!/bin/bash
# version=1.2
# cheking Maria DB OOM and restart service
#
# 2020-08-22 1.2 MB: changed datetime format
# 2020-07-19 1.1 MB: added more control
# 2020-06-06 1.0 MB: initial version
#
todaydate=$(date "+%y%m%d %H:%M")
today=$(date "+%y%m%d")
#todaydate=200515
LOGFILE="/var/log/mariadb/mariadb.log"
basedir=/root/fix-mariadb-oom
LAZY_FILE="$basedir/conf/lazy_file"
VERBOSE=0

#time_error=$(grep -i "Out of memory" $LOGFILE | tail -1 | cut -f1-2 -d\ | sed -e 's/ //' | cut -f1-2 -d:| sed -e 's/://' )
time_error=$(grep -i "Out of memory" $LOGFILE | tail -1 | cut -f1 -d'[' | sed -e 's/ *//' )
#time_error=$(date -d  "$time_error"  "+%y%m%d%H%M")
time_error=$(date -d  "$time_error" +%s)
#200813  1:04:24)
#echo $time_error

#time_current=$(date +%y%m%d%H%M) ; #echo $time_current ;
time_current=$(date +%s) ; #echo $time_current ;
#time_gap=$(expr $time_current - $time_error) ; #echo $time_gap
time_gap=$(echo $(( ($time_current - $time_error) /60 )))
time_limit=30 #minute

[ $VERBOSE -eq 0 ] && echo "$todaydate: INFO: current time: $time_current, error time: $time_error, gap:$time_gap minutes"
#time_gap=70
if [ $time_gap -lt $time_limit ] ; then
   if [ ! -f $LAZY_FILE ] ;then
      systemctl restart mariadb
      echo "$todaydate: INFO: Maria DB restarted "     
      touch $LAZY_FILE ; $(date +%s) >$LAZY_FILE
   else
      echo "$todaydate: INFO: Lazy file found checking Maria DB, it is in $time_limit  "
      if [ $(cat $LAZY_FILE) -gt $time_error] ;then
          systemctl restart mariadb
          echo "$todaydate: INFO: Lazy file found but Error time greater than  last check  restarting Maria DB,  "
      fi
   fi
else 
   if [ -f $LAZY_FILE ] ; then
      rm $LAZY_FILE
      echo "$todaydate: INFO: Lazy file removed"
   fi      
   echo "$todaydate: INFO: Maria DB is healthy no OOM  "
fi

