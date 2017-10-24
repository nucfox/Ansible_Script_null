<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '{{ mysql_ip }}';
$DB['PORT']     = '{{ mysql_port }}';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = '{{ mysql_zabbix_passwd }}';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = '{{ zabbix_server_ip }}';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = '{{ zabbix_server_ip }}';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
