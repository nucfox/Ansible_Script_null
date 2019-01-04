#!/bin/bash
#
#dependent:
#  1)yum install -y nc
#  2)python memcached_discovery.py
#########################

IP=127.0.0.1
PORT="$1"
METRIC="$2"

if [ $# -lt 2 ];then
    echo "please set argument"
    exit 1
fi

analysis_cpu() {
    result_now=${STATUS}
    time_now=$(date +%s)
    time_before=$(cut -d: -f1 /tmp/mem_${METRIC}_${PORT})
    result_before=$(cut -d: -f2 /tmp/mem_${METRIC}_${PORT})
    realres=$(awk -v rnow=$result_now -v rbe=$result_before -v tnow=$time_now -v tbe=$time_before 'BEGIN{printf "%.2f\n",(rnow-rbe)/(tnow-tbe)*100}')
    echo "$time_now:$result_now" > /tmp/mem_${METRIC}_${PORT}
}

case $METRIC in
    'rusage_system')
        STATUS=`echo "stats" | nc $IP $PORT | grep -w "$METRIC" | awk '{print $3}'`
        analysis_cpu
        echo $realres
        ;;
    'rusage_user')
        STATUS=`echo "stats" | nc $IP $PORT | grep -w "$METRIC" | awk '{print $3}'`
        analysis_cpu
        echo $realres
        ;;
    'hit_rate')
        _get_hits=`echo "stats" | nc $IP $PORT | grep -w "get_hits" | awk '{print $3}'`
        _cmd_get=`echo "stats" | nc $IP $PORT | grep -w "cmd_get" | awk '{print $3}'`
        realres=$(awk -v ghits=$_get_hits -v cget=$_cmd_get 'BEGIN{printf "%.2f",ghits/cget*100}')
        echo $realres
        ;;
        *)
        echo "Not selected metric"
        exit 0
        ;;
esac
exit 0
