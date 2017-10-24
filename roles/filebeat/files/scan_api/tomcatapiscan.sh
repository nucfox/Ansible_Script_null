#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin

TOMCAT_PATH=$1
SAVE_PATH=$2
_FIND=($(find $TOMCAT_PATH -name "api.log"))
length=${#_FIND[@]}

echo "filebeat.prospectors:" > $SAVE_PATH/conf.d/tomcat.yml
for ((i=0;i<$length;i++));do
  _NAME=$(echo ${_FIND[$i]} | sed -n 's/.*\/\{1\}\(.*\)\/\{1\}logs.*/\1/p')
  cat >> $SAVE_PATH/conf.d/tomcat.yml << EOF
- input_type: log
  tags: [$_NAME]
  include_lines: ["ERROR"]
  document_type: "tomcat"
  ignore_older: "48h"
  tail_files: true
  harvester_buffer_size: 16384
  backoff: "1s"
  paths:
    - ${_FIND[$i]}
EOF
done
