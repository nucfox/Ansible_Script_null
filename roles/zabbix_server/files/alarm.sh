#!/bin/bash
PATH=/usr/java/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:~/sbin:~/bin:/bin:/sbin
#export $HOME >> /usr/local/zabbix/debug 2>&1
#echo \""$3"\" | /usr/local/mutt/bin/mutt -s \""$2"\" $1 >> /usr/local/zabbix/debug 2>&1
#echo "$3" | /usr/local/mutt/bin/mutt -s "$2" $1 >> /usr/local/zabbix/debug 2>&1
to=$1
subject=$2
body=$3


#date >> /usr/local/zabbix/debug
#whoami >> /usr/local/zabbix/debug
#echo $HOME >> /usr/local/zabbix/debug
#echo 1 "$to" >> /usr/local/zabbix/debug
#echo 2 "$subject" >> /usr/local/zabbix/debug
#echo 3 "$body" >> /usr/local/zabbix/debug
#echo `"echo" \""$3"\" "|" "mutt" "-s" \""$2"\" $1` >> /usr/local/zabbix/debug 2>&1

cat <<EOF | mutt -s "$subject" $to
$body
EOF

