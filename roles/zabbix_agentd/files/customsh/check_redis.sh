#!/bin/sh
redis_cli_path="/usr/local/bin/redis-cli"
while getopts "p:k:P:" opt
do
        case $opt in
                p ) redis_port=$OPTARG;;
                k ) info_key=$OPTARG;;
                P ) redis_passwd=$OPTARG;;
                ? )
                echo 'parameter is wrong!'
                exit 1;;
        esac
done
if [ ! "${redis_port}" ] || [ ! "${info_key}" ];then
        echo "parameter is null"        
        exit 1
fi

if [ "${redis_passwd}" ];then
        result=`${redis_cli_path} -a ${redis_passwd} -p ${redis_port} info|grep "${info_key}:"|cut -d: -f2`
else
        result=`${redis_cli_path} -p ${redis_port} info|grep "${info_key}:"|cut -d: -f2`
fi
echo $result
