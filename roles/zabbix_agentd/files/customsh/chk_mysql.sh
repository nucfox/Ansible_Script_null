#!/bin/bash
# -------------------------------------------------------------------------------
# FileName:    check_mysql.sh
# Revision:    1.0
# Date:        2015/06/09
# Author:      DengYun
# Email:       dengyun@ttlsa.com
# Website:     www.ttlsa.com
# Description: 
# Notes:       ~
# -------------------------------------------------------------------------------
# Copyright:   2015 (c) DengYun
# License:     GPL

# User name
MYSQL_USER='user'
 
# password
MYSQL_PWD='password'
 
# Host address /IP
MYSQL_HOST='addr'
 
# port
MYSQL_PORT='port'

# Mysqladmin command path
_Mysqladmin=/usr/local/mysql/bin/mysqladmin

# MySQL command path
_Mysql=/usr/local/mysql/bin/mysql
# data connection
MYSQL_CONN="$_Mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"
MYSQL_sql="$_Mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"
# Whether the parameters are correct
if [ $# -ne "1" ];then 
    echo "arg error!" 
fi 
 
# get data
case $1 in 
    ALL)
        ${MYSQL_CONN} status
        ;;
    ALL_EX)
        ${MYSQL_CONN} extended-status
        ;;
    Uptime)
	${MYSQL_CONN} status |cut -f2 -d":"|cut -f1 -d"T"
        ;; 
    Com_update) 
        ${MYSQL_CONN} extended-status |grep -w "Com_update"|cut -d"|" -f3
        ;; 
    Slow_queries) 
        ${MYSQL_CONN} status |cut -f5 -d":"|cut -f1 -d"O"
        ;; 
    Com_select) 
        ${MYSQL_CONN} extended-status |grep -w "Com_select"|cut -d"|" -f3
        ;; 
    Com_rollback) 
        ${MYSQL_CONN} extended-status |grep -w "Com_rollback"|cut -d"|" -f3
        ;; 
    Questions) 
        ${MYSQL_CONN} status |cut -f4 -d":"|cut -f1 -d"S"
        ;; 
    Com_insert) 
        ${MYSQL_CONN} extended-status |grep -w "Com_insert"|cut -d"|" -f3
        ;; 
    Com_delete) 
	${MYSQL_CONN} extended-status |grep -w "Com_delete"|cut -d"|" -f3
        ;; 
    Com_commit) 
        ${MYSQL_CONN} extended-status |grep -w "Com_commit"|cut -d"|" -f3
        ;; 
    Bytes_sent) 
	${MYSQL_CONN} extended-status |grep -w "Bytes_sent" |cut -d"|" -f3
        ;; 
    Bytes_received) 
	${MYSQL_CONN} extended-status |grep -w "Bytes_received" |cut -d"|" -f3
        ;; 
    Com_begin) 
        ${MYSQL_CONN} extended-status |grep -w "Com_begin"|cut -d"|" -f3
        ;; 
    PING)
	${MYSQL_CONN} ping | grep -c alive
	;;
    VERSION)
	$_Mysql -V
	;;
    Slave_IO_Running)
	${MYSQL_sql} -e"show slave status \G" | grep -w "Slave_IO_Running" | awk '{print $2}'
        ;;
    Slave_SQL_Running)
        ${MYSQL_sql} -e"show slave status \G" | grep -w "Slave_SQL_Running" | awk '{print $2}'
	;;
    Seconds_Behind_Master)
        ${MYSQL_sql} -e"show slave status \G" | grep -w "Seconds_Behind_Master" | awk '{print $2}'
	;;
    Com_change_db)
	${MYSQL_CONN} extended-status |grep -w "Com_change_db" |cut -d"|" -f3
	;;
    Com_change_master)
	${MYSQL_CONN} extended-status |grep -w "Com_change_master" |cut -d"|" -f3
        ;;
    Com_lock_tables)
	${MYSQL_CONN} extended-status |grep -w "Com_lock_tables" |cut -d"|" -f3
        ;;
    Binlog_cache_use)
	${MYSQL_CONN} extended-status |grep -w "Binlog_cache_use" |cut -d"|" -f3
        ;;
    Slave_running)
	${MYSQL_CONN} extended-status |grep -w "Slave_running" |cut -d"|" -f3
        ;;
    Questions)
	${MYSQL_CONN} extended-status |grep -w "Questions" |cut -d"|" -f3
        ;;
    Innodb_row_lock_time)
	${MYSQL_CONN} extended-status |grep -w "Innodb_row_lock_time" |cut -d"|" -f3
        ;;
    Innodb_row_lock_waits)
	${MYSQL_CONN} extended-status |grep -w "Innodb_row_lock_waits" |cut -d"|" -f3
        ;;
    Threads_cached)
	${MYSQL_CONN} extended-status |grep -w "Threads_cached" |cut -d"|" -f3
        ;;
    Table_locks_waited)
	${MYSQL_CONN} extended-status |grep -w "Table_locks_waited" |cut -d"|" -f3
        ;;
    Max_used_connections)
	${MYSQL_CONN} extended-status |grep -w "Max_used_connections" |cut -d"|" -f3
        ;;
    Connections)
	${MYSQL_CONN} extended-status |grep -w "Connections" |cut -d"|" -f3
        ;;
    Handler_commit)
	${MYSQL_CONN} extended-status |grep -w "Handler_commit" |cut -d"|" -f3
        ;;
    Sort_merge_passes)
	${MYSQL_CONN} extended-status |grep -w "Sort_merge_passes" |cut -d"|" -f3
        ;;
    Key_blocks_used)
	${MYSQL_CONN} extended-status |grep -w "Key_blocks_used" |cut -d"|" -f3
        ;;
    MySql_TPS)
	commit=`${MYSQL_CONN} extended-status |grep -w "Com_commit" |cut -d"|" -f3`
	rollback=`${MYSQL_CONN} extended-status |grep -w "Com_rollback" |cut -d"|" -f3`
	result=`expr $commit + $rollback`
	echo $result
        ;;
    key_buffer_read_hits)
	value1=`${MYSQL_CONN} extended-status |grep -w "Key_reads" |cut -d"|" -f3`
	value2=`${MYSQL_CONN} extended-status |grep -w "Key_read_requests" |cut -d"|" -f3`
	[ $value1 -eq 0 -a $value2 -eq 0 ] && echo "0" && exit 0
	result=`awk -v arg1="$value1" -v arg2="$value2" 'BEGIN{printf 1-arg1/arg2}'`
	echo $result
	;;
    key_buffer_write_hits)
	value1=`${MYSQL_CONN} extended-status |grep -w "Key_writes" |cut -d"|" -f3`
	value2=`${MYSQL_CONN} extended-status |grep -w "Key_write_requests" |cut -d"|" -f3`
	[ $value1 -eq 0 -a $value2 -eq 0 ] && echo "0" && exit 0
	result=`awk -v arg1="$value1" -v arg2="$value2" 'BEGIN{printf 1-arg1/arg2}'`
	echo $result
	;;
    Innodb_buffer_read_hits)
	value1=`${MYSQL_CONN} extended-status |grep -w "Innodb_buffer_pool_reads" |cut -d"|" -f3`
	value2=`${MYSQL_CONN} extended-status |grep -w "Innodb_buffer_pool_read_requests" |cut -d"|" -f3`
	[ $value1 -eq 0 -a $value2 -eq 0 ] && echo "0" && exit 0
	result=`awk -v arg1="$value1" -v arg2="$value2" 'BEGIN{printf 1-arg1/arg2}'`
	echo $result
	;;
    Query_cache_hits)
	value1=`${MYSQL_CONN} extended-status |grep -w "Qcache_hits" |cut -d"|" -f3`
	value2=`${MYSQL_CONN} extended-status |grep -w "Qcache_inserts" |cut -d"|" -f3`
	[ $value1 -eq 0 -a $value2 -eq 0 ] && echo "0" && exit 0
	result=`awk -v arg1="$value1" -v arg2="$value2" 'BEGIN{printf arg1/(arg1+arg2)}'`
	echo $result
	;;
    Thread_cache_hits)
	value1=`${MYSQL_CONN} extended-status |grep -w "Threads_cached" |cut -d"|" -f3`
	value2=`${MYSQL_CONN} extended-status |grep -w "Connections" |cut -d"|" -f3`
	[ $value1 -eq 0 -a $value2 -eq 0 ] && echo "0" && exit 0
	result=`awk -v arg1="$value1" -v arg2="$value2" 'BEGIN{printf 1-arg1/arg2}'`
	echo $result
	;;
        *) 
        echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Com_insert|Com_delete|Com_commit|Bytes_sent|Bytes_received|Com_begin|PING|VERSION|Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master)"
        ;; 
esac
