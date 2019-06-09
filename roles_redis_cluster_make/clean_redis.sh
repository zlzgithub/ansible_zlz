timeout 3 systemctl stop sentinel*
timeout 3 systemctl stop redis*

rm -rf /opt/redis/bin
rm -f /usr/bin/redis*
rm -f /etc/systemd/system/multi-user.target.wants/sentinel*
rm -f /etc/systemd/system/multi-user.target.wants/redis*
rm -f /etc/tmpfiles.d/redis.conf
rm -rf /var/lib/redis
rm -rf /var/run/redis
rm -f /etc/alternatives/redis*

systemctl stop keepalived
systemctl stop haproxy

rm -rf /etc/haproxy
rm -rf /etc/keepalived
rm -rf /etc/redis

ps -ef |grep redis_ |grep -v grep |awk '{print $2}' |xargs kill -9
ps -ef |grep /opt/redis/bin/redis-server |grep -v grep |awk '{print $2}' |xargs kill -9

