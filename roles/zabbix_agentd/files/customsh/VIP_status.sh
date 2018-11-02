#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:~/sbin:~/bin
source /etc/profile

#example: VIP=10.108.1.15
VIP=VIPaddr

keepalived_conf="/etc/keepalived/keepalived.conf"

dev=`grep -w "interface" $keepalived_conf|awk '{print $2}'`

case $1 in
	VIP_status)
	ip -f inet a ls $dev | grep $VIP | wc -l
	;;
	keepalived_status)
	result=$(ps -ef | grep -v grep |grep -w "keepalived" | wc -l)
	[ $result -ne 3 ] && echo 0 && exit 0
	echo 1
	;;
	*)
	echo "Usage:$0(VIP_status|keepalived_status)"
	;;
esac
