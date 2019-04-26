#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:~/sbin:~/bin
source /etc/profile

javaname=$1
_IP=172.17.118.39
_timeout=5
status_number=0
#res=$1

case "$javaname" in
    "ace-config")res=$(timeout $_timeout curl -s $_IP:8700/actuator/health | jq -r .status);;
    "ace-auth-server")res=$(timeout $_timeout curl -s $_IP:8787/actuator/health | jq -r .status);;
    "ace-gateway")res=$(timeout $_timeout curl -s $_IP:8765/actuator/health | jq -r .status);;
    "ace-order")res=$(timeout $_timeout curl -s $_IP:8705/actuator/health | jq -r .status);;
    "ace-score")res=$(timeout $_timeout curl -s $_IP:8766/actuator/health | jq -r .status);;
    "ace-organize")res=$(timeout $_timeout curl -s $_IP:8767/actuator/health | jq -r .status);;
    "ace-goods")res=$(timeout $_timeout curl -s $_IP:8764/actuator/health | jq -r .status);;
    "ace-tool")res=$(timeout $_timeout curl -s $_IP:8712/actuator/health | jq -r .status);;
    "ace-center")res=$(timeout $_timeout curl -s $_IP:8761/actuator/health | jq -r .status);;
    "ace-scheduled")res=$(timeout $_timeout curl -s $_IP:8763/actuator/health | jq -r .status);;
    "ace-admin")res=$(timeout $_timeout curl -s $_IP:8762/actuator/health | jq -r .status);;
    "*")exit 1;;
esac

#echo $res
if [ ${res:-x} == 'UP' ]; then
  status_number=1
elif [ ${res:-x} == 'DOWN' ]; then
  status_number=2
else
  status_number=3
fi
echo $status_number
exit 0
