systemctl stop sentinel_26380.service
systemctl stop sentinel_26379.service
systemctl stop redis_6601.service
systemctl stop redis_6600.service
rm -rf /opt/redis/bin/
rm -f /usr/bin/redis-*
rm -f /etc/systemd/system/multi-user.target.wants/sentinel_263*
rm -f /etc/systemd/system/multi-user.target.wants/redis_660*
rm -f /etc/tmpfiles.d/redis.conf
rm -rf /var/lib/redis
rm -rf /var/run/redis
rm -f /etc/alternatives/redis-*
systemctl stop keepalived
systemctl stop haproxy
rm -rf /etc/haproxy
rm -rf /etc/keepalived
rm -rf /etc/redis