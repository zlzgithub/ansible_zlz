#!/bin/bash


redis_list=$1
redis_list=${redis_list:="172.17.0.2:6600 172.17.0.4:6600 172.17.0.2:6601"}
master_host=""
master_port=""
master_host_port=""
sds=$2
haproxy_cfg=/etc/haproxy/haproxy.cfg

REDIS_CLI=redis-cli

chk_master(){
    host=$(echo "$1" |cut -d: -f1)
    port=$(echo "$1" |cut -d: -f2)
    timeout 1 $REDIS_CLI -h $host -p $port info | grep role:master >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        master_host=$host
        master_port=$port
        master_host_port="$master_host_port $master_host:$master_port"
    fi
}

get_info(){
    for instance in $redis_list
    do
        echo $instance ...
        chk_master $instance
        if [ -n "$master_host" ]; then
            echo $master_host,$master_port
            #break
        fi
    done
}

mod_haproxy_cfg(){
    if [ "$sds" = "--sds" ]; then
        sed -n '1,/^backend redis-write/p' $haproxy_cfg |sed "/$master_host_port/d"
    else
        sed -n '1,/^backend redis-write/p' $haproxy_cfg
    fi

    echo "    mode        tcp"
    echo "    balance     roundrobin"

#    n=$(echo $master_host_port |wc -w)
#    if [ $n -ge 2 ]; then
#        sleep 5
#        master_host_port=""
#        master_host=""
#        master_port=""
#        get_info >/dev/null
#    fi

    echo "    server redis0 $master_host:$master_port check"

    echo ""

    sed -n '/^listen stats/,$p' $haproxy_cfg
}

get_info
mod_haproxy_cfg > ${haproxy_cfg}.tmp
mv ${haproxy_cfg}.tmp $haproxy_cfg
#systemctl restart haproxy
systemctl reload haproxy.service

