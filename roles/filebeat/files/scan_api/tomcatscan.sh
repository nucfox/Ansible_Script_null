#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin

SAVE_PATH="."
_FIND=($(find /u06/etsuser/tomcat -name "catalina.out"))
length=${#_FIND[@]}

echo "filebeat.prospectors:" > $SAVE_PATH/tomcat.yml
for ((i=0;i<$length;i++));do
  _NAME=$(echo ${_FIND[$i]} | sed -n 's/.*\(tomcat-[^\/]*\)\/.*/\1/p')
  cat >> $SAVE_PATH/tomcat.yml << EOF
- input_type: log
  tags: [$_NAME]
  include_lines: ["ERROR"]
  document_type: "tomcat"
  ignore_older: "48h"
  tail_files: true
  harvester_buffer_size: 16384
  backoff: "1s"
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]]{1}[0-9]{2}:[0-9]{2}:[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  multiline.timeout: 5s
  paths:
    - ${_FIND[$i]}
EOF
done
