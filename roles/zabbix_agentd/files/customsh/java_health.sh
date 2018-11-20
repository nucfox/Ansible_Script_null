#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:~/sbin:~/bin
source /etc/profile

javaname=$1
_IP=172.17.118.34
_timeout=5

case "$javaname" in
    "ace-config")timeout $_timeout curl -s $_IP:8700/actuator/health | jq -r .status;;
    "ace-auth-server")timeout $_timeout curl -s $_IP:8787/actuator/health | jq -r .status;;
    "ace-gateway")timeout $_timeout curl -s $_IP:8765/actuator/health | jq -r .status;;
    "ace-order")timeout $_timeout curl -s $_IP:8705/actuator/health | jq -r .status;;
    "ace-score")timeout $_timeout curl -s $_IP:8766/actuator/health | jq -r .status;;
    "ace-organize")timeout $_timeout curl -s $_IP:8767/actuator/health | jq -r .status;;
    "ace-goods")timeout $_timeout curl -s $_IP:8764/actuator/health | jq -r .status;;
    "ace-tool")timeout $_timeout curl -s $_IP:8712/actuator/health | jq -r .status;;
    "ace-center")timeout $_timeout curl -s $_IP:8761/actuator/health | jq -r .status;;
    "ace-scheduled")timeout $_timeout curl -s $_IP:8763/actuator/health | jq -r .status;;
    "*")exit 1;;
esac
