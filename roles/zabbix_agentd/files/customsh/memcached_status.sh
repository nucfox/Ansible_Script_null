#!/bin/bash
#
#Auth: Pengdongwen
#Blog: www.ywnds.com
#Email: 593265947@qq.com
#Desc: memcached status monitoring 
#dependent:
#  1)yum install -y nc
#  2)python memcached_discovery.py
#########################
 
IP=127.0.0.1 
PORT="$1"
METRIC="$2"
 
if [ $# -lt 2 ];then
    echo "please set argument"
    exit 1
fi
 
STATUS=`echo "stats" | nc $IP $PORT | grep -w "$METRIC" | awk '{print $3}'`
echo $STATUS
exit 0
