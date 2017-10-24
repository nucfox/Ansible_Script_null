#!/bin/bash
PATH=/usr/java/jdk1.7.0_45/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin
_NAME=$1
Jcase=`echo $2 | tr [a-z] [A-Z]`
_CLASS=`echo $3 | tr [a-z] [A-Z]`
case "$_CLASS" in
        "JAVA")
                _PID=`ps -e -o "pid,args" | grep "java.*-jar.*$_NAME" | egrep -v "grep|jvm_status.sh" | awk '{print $1}'`
        ;;
        "TOMCAT")
                _PID=$(ps -e -o "pid,args" | grep "$_NAME/temp" | egrep -v "grep|jvm_status.sh" | awk '{print $1}')
        ;;
        *)
                exit 1
        ;;
esac
#echo $_PID
#_PID=$(ps -e -o "pid,args" | grep "$_JAVA_NAME" | egrep -v "grep|jvm_status.sh" | awk '{print $1}')
#_PID=`ps -e -o "pid args" | grep "java.*-jar.*etsv.*$JNAME" | grep -v grep | awk '{print $1}'`

expr $_PID + 1 > /dev/null 2>&1
[ $? -eq 2 ] || [ ! -n "$_PID" ] && echo "-1" && exit 2
sleep 1
function JSTAT(){
	_NUM=$1
	sudo -u etsuser jstat -gc $_PID | awk 'NR>1{print $a}' a=$_NUM
}

case "$Jcase" in
	"JVMS0C")
		JSTAT 1
	;;
	"JVMS1C")
		JSTAT 2
	;;
	"JVMS0U")
		JSTAT 3
	;;
	"JVMS1U")
		JSTAT 4
	;;
	"JVMEC")
		JSTAT 5
	;;	
	"JVMEU")
		JSTAT 6
	;;
	"JVMOC")
		JSTAT 7
	;;
	"JVMOU")
		JSTAT 8
	;;
	"JVMPC")
		JSTAT 9
	;;
	"JVMPU")
		JSTAT 10
	;;
	"JVMYGC")
		JSTAT 11
	;;
	"JVMYGCT")
		JSTAT 12
	;;
	"JVMFGC")
		JSTAT 13
	;;
	"JVMFGCT")
		JSTAT 14
	;;
	"JVMGCT")
		JSTAT 15
	;;
	help|*)
		echo $"Usage: $0 {javaname} {JVMS0C|JVMS1C|JVMS0U|JVMS1U|JVMEC|JVMEU|JVMOC|JVMOU|JVMPC|JVMPC|JVMPU|JVMYGC|JVMYGCT|JVMFGC|JVMFGCT|JVMGCT}"

	exit 1
	;;
esac

exit 0
