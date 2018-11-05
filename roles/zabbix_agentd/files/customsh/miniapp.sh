#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:~/sbin:~/bin
source /etc/profile

_NAME=$1

_PID=`ps -e -o "pid,args" |grep -v grep| grep -v miniapp.sh| grep "$_NAME" | awk '{print $1}'`

expr $_PID + 1 > /dev/null 2>&1
[ $? -eq 2 ] || [ ! -n "$_PID" ] && echo "-1" && exit 2
sleep 1

cat /proc/$_PID/status | grep VmRSS | awk '{print $2}'
exit 0
