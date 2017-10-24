#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import commands

(status, output) = commands.getstatusoutput('''sudo netstat -tlnp|grep 'redis-server'|awk '{print $4}'|awk -F':' '{print $(NF)}'|sort -u''')
outputs = output.split('\n')
ports = []
for port in  outputs:
    ports += [{'{#REDISPORT}': port}]

print json.dumps({'data':ports},sort_keys=True,indent=4)
