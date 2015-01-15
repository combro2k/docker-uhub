#!/bin/bash

PASS=${UHUB_PASS:-$(pwgen -s 12 1)}

if [ ! -z "$IPV6ADDR" ]; then
	echo  $IPV6ADDR
	ip -6 addr add "$IPV6ADDR" dev eth0
fi

sleep 2

if [ ! -z "$IPV6GW" ]; then
	echo $IPV6GW
	ip -6 route add  default via "$IPV6GW" dev eth0
fi

if [[ ! -f "/data/uhub.conf" ]]
then
    cp /etc/uhub/uhub.conf /data/uhub.conf
    sed -i 's#/etc/uhub/#/data/#g' /data/uhub.conf
fi

if [[ ! -f "/data/users.conf" ]]
then
    touch /data/users.conf
fi

if [[ ! -f "/data/motd.txt" ]]
then
    touch /data/motd.txt
fi

if [[ ! -f "/data/rules.txt" ]]
then
    touch /data/rules.txt
fi

if [[ ! -f "/data/plugins.conf" ]]
then
    cp /etc/uhub/plugins.conf /data/plugins.conf
    sed -i 's#/etc/uhub/#/data/#g' /data/plugins.conf
fi

if [[ ! -f "/data/users.db" ]]
then
    uhub-passwd /data/users.db create
    uhub-passwd /data/users.db add admin ${PASS} admin
    echo "Username: admin"
    echo "Password: ${PASS}"
    echo ${PASS} > /data/passwd
    echo ""
    echo "To change type docker exec -ti docker_name uhub-passwd /data/users.db pass admin your-password"
fi

/usr/bin/uhub -c /data/uhub.conf
