#!/bin/bash

PATH=/usr/java/jdk1.7.0_45/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin

#function JAVALIST(){
JAVApage=$(ps -e -o "pid,args"|egrep java | egrep ets[^/]*-[^/]*\.jar | sed -n 's/.*\(etsv.*\.jar\).*/\1/p')
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
