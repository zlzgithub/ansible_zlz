#!/bin/sh


REDIS_CLI=redis-cli
inner_ip=$(ifconfig eth0 |awk '/inet /{print $2}')
for port in 6600 6601
do
  timeout 1 $REDIS_CLI -p $port info | grep role:master >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    sed -n '/^backend redis-write/,$'p /etc/haproxy/haproxy.cfg  |grep $inner_ip:$port >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        sh /etc/haproxy/haproxy.sh >/dev/null
    fi
    exit 0
  fi
done
exit 1

