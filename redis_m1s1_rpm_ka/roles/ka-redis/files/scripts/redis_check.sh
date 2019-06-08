#!/bin/bash


REDIS_PASS=cY1PxmQNfVOi62WBXXh1saHLZE31O3Gw
ALIVE=`redis-cli -a $REDIS_PASS -h $1 -p $2 PING`
LOGFILE="/var/log/keepalived-redis-check.log"
echo "[CHECK]" >> $LOGFILE
date >> $LOGFILE

if [ $ALIVE == "PONG" ]; then
    echo "Success: redis-cli -h $1 -p $2 PING $ALIVE" >> $LOGFILE 2>&1
    exit 0
else
    echo "Failed:redis-cli -h $1 -p $2 PING $ALIVE " >> $LOGFILE 2>&1
    exit 1
fi
