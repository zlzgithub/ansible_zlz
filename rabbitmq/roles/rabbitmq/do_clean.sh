#!/bin/sh

rabbitmqctl stop
yum remove rabbitmq-server.noarch -y
ps -ef |grep epmd |grep -v grep |awk '{print $2}' |xargs kill -9
ps -ef |grep erlang |grep -v grep |awk '{print $2}' |xargs kill -9
rm -rf /var/lib/rabbitmq
rm -rf /etc/rabbitmq
