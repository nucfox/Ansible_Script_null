#!/bin/bash
PATH=/usr/java/default/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin

TOMCATpage=$(ps -e -o "pid args" | grep tmpdir=.*tomcat.*/temp | egrep -v "grep|tomcatscreen")
#TOMCAT_PID=($(echo "$TOMCATpage" | gawk '{print $1}'))
#TOMCAT_NAME=($(echo "$TOMCATpage" |  sed 's/^.*\/tomcat/tomcat/g' | sed 's/\/temp.*$//g'| grep -xv tomcat/g))
TOMCAT_NAME=($(echo "$TOMCATpage" | sed -n 's/.*tmpdir=.*\/\{1\}\(.*\)\/temp.*/\1/p'))

#TOMCATARRAY=(`ps -e -o "pid args" | grep tomcat | egrep -v "grep|tomcatscreen" | sed 's/^.*\/tomcat/tomcat/g' | sed 's/\/temp.*$//g' | grep -xv tomcat/g`)

length=${#TOMCAT_NAME[@]}
printf "{\n"
printf '\t'"\"data\":["
for ((i=0;i<$length;i++));do
        printf '\n\t\t{'
#        printf "\"{#TOMCAT_PID}\":\"${TOMCAT_PID[$i]}\",\"{#TOMCAT_NAME}\":\"${TOMCAT_NAME[$i]}\"}"
        printf "\"{#TOMCAT_NAME}\":\"${TOMCAT_NAME[$i]}\"}"
        if [ $i -lt $[$length-1] ];then
                printf ','
        fi
done
printf "\n\t]\n"
printf "}\n"
