#!/bin/bash

MTU0=1500
MTUx=9000
DOMAIN="jtest.pivotal.io"
DNS0="192.168.0.199"
DNS1="8.8.8.8"
DNS2="168.126.63.1"
NET0="192.168.0.0/24"
NET1="192.168.1.0/24"
NET2="192.168.2.0/24"
GW0="192.168.0.1"
GW1="192.168.1.1"
GW2="192.168.2.1"
NETDEV_PREFIX=enp


# SEQ,NET,TABLE,PRIO,MTU,NETNUM,NETWORK_RANGE,ROUTABLE,AUTOCONN,CONNPERM
INFO_TABLE="
0,192.168.0.17,200,103,$MTU0,1s0,$NET0,yes,$GW0,yes,no
1,192.168.1.17,201,102,$MTUx,7s0,$NET1,yes,$GW1,no,yes
2,192.168.2.17,202,101,$MTUx,8s0,$NET2,no,$GW2,yes,no
"

ENDIP=$(hostname | cut -d 0 -f 2)

for i in $(echo $INFO_TABLE)
do

    SEQ=$(echo $i | cut -d , -f 1)
    IPNUM=$(echo $i | cut -d , -f 2)
    TABLE=$(echo $i | cut -d , -f 3)
    PRIO=$(echo $i | cut -d , -f 4)
    MTU=$(echo $i | cut -d , -f 5)
    NETNUM=$(echo $i | cut -d , -f 6)
    NET=$(echo $i | cut -d , -f 7)
    ROUTABLE=$(echo $i | cut -d , -f 8)
    GATEWAY=$(echo $i | cut -d , -f 9)
    AUTOCONN=$(echo $i | cut -d , -f 10)
    CONNPERM=$(echo $i | cut -d , -f 11)
    if [ "$CONNPERM" == "yes" ]; then
      CONN_PERM_OPTIONS="connection.permission user:root"
    elif [ "$CONNPERM" == "no" ]; then
      CONN_PERM_OPTIONS=""
    else
      echo "No Options"
      exit
    fi


    nmcli connection delete conn$SEQ
    # nmcli connection delete eth$SEQ
    # nmcli connection delete enp$NETNUM
    nmcli con add con-name conn$SEQ type ethernet ifname $NETDEV_PREFIX$NETNUM ipv4.method auto
    nmcli con modify conn$SEQ ipv4.method manual ipv4.address $IPNUM$ENDIP/24
    nmcli con modify conn$SEQ ipv4.gateway $GATEWAY
    nmcli connection modify conn$SEQ 802-3-ethernet.mtu $MTU
    nmcli connection modify conn$SEQ ipv4.dns $DNS0,$DNS1,$DNS2,$DNS3 ipv4.dns-search $DOMAIN
    nmcli connection modify conn$SEQ ipv4.routes "$NET table=$TABLE" ipv4.routing-rules "priority $PRIO from $IPNUM$ENDIP table $TABLE"
    nmcli connection modify conn$SEQ ipv6.method "disabled"
    nmcli con mod conn$SEQ ipv4.never-default $ROUTABLE connection.autoconnect $AUTOCONN $CONN_PERM_OPTIONS
    echo "nmcli con mod conn$SEQ ipv4.never-default $ROUTABLE connection.autoconnect $AUTOCONN $CONN_PERM_OPTIONS"
    nmcli con up conn$SEQ

done

# [ Examples ]
# nmcli general permissions
# nmcli connection show conn0 ( conn1, conn2 )
#
# [ connection.permissions ]
# An array of strings defining what access a given user has to this connection.
# If this is NULL or empty, all users are allowed to access this connection;
# otherwise users are allowed if and only if they are in this list. When this is not empty,
# the connection can be active only when one of the specified users is logged into an active session.
# Each entry is of the form “[type]:[id]:[reserved]”; for example, “user:dcbw:blah”.
# At this time only the “user” [type] is allowed. Any other values are ignored and reserved for future use.
# [id] is the username that this permission refers to, which may not contain the “:” character.
# Any [reserved] information present must be ignored and is reserved for future use.
# All of [type], [id], and [reserved] must be valid UTF-8.


# Need reboot to apply or check if restaring NM is possible
# nmcli connection modify conn1 ipv4.routes "192.168.0.0/24 table=100" +ipv4.routes "0.0.0.0/0 192.168.0.18$ENDIP table=100" ipv4.routing-rules "priority 101 from 192.168.0.1 table 100"
# nmcli connection modify conn2 ipv4.routes "192.168.1.0/24 table=100" +ipv4.routes "0.0.0.0/0 192.168.1.15$ENDIP table=100" ipv4.routing-rules "priority 101 from 192.168.1.1 table 100"
# nmcli connection modify conn3 ipv4.routes "192.168.1.0/24 table=200" +ipv4.routes "0.0.0.0/0 192.168.1.20$ENDPI table=200" ipv4.routing-rules "priority 102 from 192.168.1.1 table 200"

