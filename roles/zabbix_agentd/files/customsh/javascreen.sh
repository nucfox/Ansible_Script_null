#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:~/sbin:~/bin
source /etc/profile

#function JAVALIST(){
JAVApage=$(ps -e -o "pid,args"|egrep java | egrep ace[^/]*-[^/]*\.jar | sed -n 's/.*\(ace.*\.jar\).*/\1/p')
#JAVA_PID=($(echo "$JAVApage" | gawk '{print $1}'))
#JAVA_NAME=($(echo "$JAVApage" | gawk '{print $2}' |sed s/.jar$//g | sed 's/\(.\)\{14\}$//'))
#JAVA_NAME=($(echo "$JAVApage"  |sed s/.jar$//g | sed 's/\(.\)\{14\}$//'))
JAVA_NAME=($(echo "$JAVApage"  |sed s/.jar$//g))
#JAVA_NAME=($(echo "$JAVApage" | gawk '{print $2}'))
#JAVAARRAY=(`ps -e -o "args" | egrep "java.*-jar" | grep -v grep | gawk BEGIN'{ FS = "-";OFS = "-" } {print $3,$4}' | tr -d [0-9]|sed s/.jar$//g`)
#}
length=${#JAVA_NAME[@]}
printf "{\n"
printf '\t'"\"data\":["
for ((i=0;i<$length;i++));do
	printf '\n\t\t{'	
	printf "\"{#JAVA_NAME}\":\"${JAVA_NAME[$i]}\"}"
	if [ $i -lt $[$length-1] ];then
		printf ','
	fi
done
printf "\n\t]\n"
printf "}\n"
