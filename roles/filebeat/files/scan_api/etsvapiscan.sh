#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin

SCAN_PATH="$1"
SAVE_PATH="$2"
_FIND=($(find "$SCAN_PATH"* -name "api.log"))
length=${#_FIND[@]}

echo "filebeat.prospectors:" > $SAVE_PATH/conf.d/etsv.yml
for ((i=0;i<$length;i++));do
  _NAME=$(echo ${_FIND[$i]} | sed -n 's/.*\/\{1\}\(.*\)\/\{1\}logs.*/\1/p')
  cat >> $SAVE_PATH/conf.d/etsv.yml << EOF
- input_type: log
  tags: [$_NAME]
  include_lines: ["ERROR"]
  document_type: "etsv"
  ignore_older: "48h"
  tail_files: true
  harvester_buffer_size: 16384
  backoff: "1s"
  paths:
    - ${_FIND[$i]}
EOF
done
