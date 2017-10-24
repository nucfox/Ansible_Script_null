#!/bin/bash
PATH=/usr/java/jdk1.7.0_45/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin


_NAME=$1

_CLASS=`echo $2 | tr [a-z] [A-Z]`
case "$_CLASS" in
        "JAVA")
                _PID=`ps -e -o "pid,args" | grep "java" |grep "$_NAME\.jar" | egrep -v "grep|vm_status.sh" | awk '{print $1}'`
        ;;
        "TOMCAT")
		_PID=$(ps -e -o "pid,args" | grep "$_NAME/temp" | egrep -v "grep|vm_status.sh" | awk '{print $1}')
        ;;
        *)
                exit 1
        ;;
esac

#_PID=$(ps -e -o "pid,args" | grep "$_NAME/temp" | egrep -v "grep|vm_status.sh" | awk '{print $1}')

expr $_PID + 1 > /dev/null 2>&1
[ $? -eq 2 ] || [ ! -n "$_PID" ] && echo "-1" && exit 2
sleep 1

cat /proc/$_PID/status | grep VmRSS | awk '{print $2}'

exit 0
