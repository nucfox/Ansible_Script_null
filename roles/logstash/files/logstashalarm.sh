#!/bin/bash

PATH=/usr/java/default/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:~/sbin:~/bin:$PATH

subject=$1
body=$2
dir=/tmp/logstash_mail_time
mkdir -p $dir

mail_date=`date "+%s"`
[ -f $dir/$subject ] && file_time=`cat $dir/$subject` || file_time=0
file_date=${file_time:-0}
Dvalue=`expr $mail_date - $file_date`

if [ ${Dvalue} -lt 3600 ];then
   exit 0
else
   rm -f $dir/$subject
fi

echo "$mail_date" > $dir/$subject

cat <<EOF | /usr/local/mutt/bin/mutt -s "$subject" jiang9217@foxmail.com
$body
EOF
