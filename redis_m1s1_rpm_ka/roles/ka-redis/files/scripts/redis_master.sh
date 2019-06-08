#!/bin/bash

REDIS_PASS=cY1PxmQNfVOi62WBXXh1saHLZE31O3Gw
REDISCLI="redis-cli -a $REDIS_PASS -h $1 -p $3"
ALIVE=`redis-cli -a $REDIS_PASS -h $2 -p $3 PING`
IsMaster=`redis-cli -a $REDIS_PASS -h $2 -p $3 role|grep master|wc -l`

LOGFILE="/var/log/keepalived-redis-state.log"
echo "[master]" >> $LOGFILE
date >> $LOGFILE
echo "Being master...." >> $LOGFILE 2>&1

if [ $ALIVE == "PONG" ] && [ $IsMaster == 1 ]; then
    echo "Run REPLICAOF cmd ... " >> $LOGFILE
    $REDISCLI REPLICAOF $2 $3 >> $LOGFILE  2>&1
    $REDISCLI CONFIG SET MASTERAUTH $REDIS_PASS >> $LOGFILE 2>&1
    sleep 10
fi

echo "Run REPLICAOF NO ONE cmd ..." >> $LOGFILE
$REDISCLI REPLICAOF NO ONE >> $LOGFILE 2>&1
