#!/bin/bash

REDIS_PASS=cY1PxmQNfVOi62WBXXh1saHLZE31O3Gw
REDISCLI="redis-cli -a $REDIS_PASS -h $1 -p $3"
ALIVE=`redis-cli -a $REDIS_PASS -h $2 -p $3 PING`
IsSlave=`redis-cli -a $REDIS_PASS -h $2 -p $3 role|grep slave|wc -l`

LOGFILE="/var/log/keepalived-redis-state.log"
echo "[BACKUP]" >> $LOGFILE
date >> $LOGFILE
echo "Being slave...." >> $LOGFILE 2>&1

if [ $ALIVE == "PONG" ] && [ $IsMaster == 1 ]; then
    sleep 15
fi

echo "Run REPLICAOF cmd ..." >> $LOGFILE 2>&1
$REDISCLI REPLICAOF $2 $3 >> $LOGFILE
$REDISCLI CONFIG SET MASTERAUTH $REDIS_PASS >> $LOGFILE
