#!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:~/sbin:~/bin
source /etc/profile

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

analysis_stats() {
    time_now=$(date +%s)
    time_before=$(cut -d: -f1 /tmp/redis_${info_key}_${redis_port})
    result_before=$(cut -d: -f2 /tmp/redis_${info_key}_${redis_port})
    realres=$(awk -v rnow=$result_now -v rbe=$result_before -v tnow=$time_now -v tbe=$time_before 'BEGIN{printf "%.2f\n",(rnow-rbe)/(tnow-tbe)*100}')
    echo "$time_now:$result_now" > /tmp/redis_${info_key}_${redis_port}
}

if [ "${redis_passwd}" ];then
        result_now=$(${redis_cli_path} -a ${redis_passwd} -p ${redis_port} info|grep "${info_key}:"|cut -d: -f2)
        analysis_stats
else
        result_now=$(${redis_cli_path} -p ${redis_port} info|grep "${info_key}:"|cut -d: -f2)
        analysis_stats
fi
echo $realres
