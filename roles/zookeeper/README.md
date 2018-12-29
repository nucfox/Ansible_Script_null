集群需要2*n+1台服务器  
需要java环境  
[zookeeper docker](https://hub.docker.com/_/zookeeper)  
[zookeeper 文档configuration](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_configuration)  
---
参数|docker环境变量|说明
---|---|---
clientPort|ZOO_PORT|侦听客户端连接的端口; 也就是客户端尝试连接的端口
tickTime|ZOO_TICK_TIME|单个tick的长度,即ZooKeeper使用的基本时间单位,以毫秒为单位.它用于调节心跳和超时
initLimit|ZOO_INIT_LIMIT|以tick为单位的时间量,以允许followers连接并同步到leader.如果ZooKeeper管理的数据量很大，则根据需要增加此值
syncLimit|ZOO_SYNC_LIMIT|以tick为单位的时间量,以允许followers与ZooKeeper同步.如果粉丝落后于leader,他们就会被淘汰
autopurge.snapRetainCount|ZOO_AUTOPURGE_SNAPRETAINCOUNT|3.4.0中的新增 功能:启用后,ZooKeeper自动清除功能分别在dataDir和dataLogDir中保留autopurge.snapRetainCount最新快照和相应的事务日志,并删除其余日志 .默认为3.最小值为3
autopurge.purgeInterval|ZOO_AUTOPURGE_PURGEINTERVAL|3.4.0中的新增功能:必须触发清除任务的时间间隔(以小时为单位).设置为正整数(1和更高)以启用自动清除.默认为0.
maxClientCnxns|ZOO_MAX_CLIENT_CNXNS|限制由IP地址标识的单个客户端可以对ZooKeeper集合的单个成员进行的并发连接数(在套接字级别).这用于防止某些类别的DoS攻击,包括文件描述符耗尽.默认值为60.将此值设置为0将完全删除并发连接的限制.
server.x=[hostname]:nnn[:nnn]|ZOO_SERVERS|构成ZooKeeper集合的服务器.当服务器启动时,它通过在数据目录中查找文件myid来确定它是哪个服务器.myid标示要写到快照目录下面myid文件里.第一个端口是followers和leader之间的通信端口,默认是2888,第二个端口是leader选举的端口,集群刚启动的时候选举或者leader挂掉之后进行新的选举的端口默认是3888
dataDir|ZOO_DATA_DIR|ZooKeeper存储内存数据库快照的位置,除非另有说明,否则为数据库更新的事务日志;放置事务日志的位置要小心.专用的事务日志设备是始终如一的良好性能的关键.将日志置于繁忙的设备上会对性能产生负面影响
dataLogDir|ZOO_DATA_LOG_DIR|此选项将指示计算机将事务日志写入dataLogDir而不是dataDir.这允许使用专用的日志设备,并有助于避免日志记录和快照之间的竞争;拥有专用的日志设备会对吞吐量和稳定的延迟产生很大影响.强烈建议专用日志设备并将dataLogDir设置为指向该设备上的目录,然后确保将dataDir指向不驻留在该设备上的目录  
---
&emsp;myid文件需要存放于快照目录中,取值范围1-255,myid与server.X一一对应,所以server.1的myid为1,id在集群中必须是唯一的  
&emsp;docker环境变量ZOO_MY_ID  
```
#server.1
echo "1" > /data/myid
```
&emsp;ansible安装需要为host定义inventory变量ZOO_MY_ID,以区分myid  
##### [zookeeper 4字命令](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_zkCommands)  
##### [连接zookeeper](https://zookeeper.apache.org/doc/current/zookeeperStarted.html#sc_ConnectingToZooKeeper) 
```
$ bin/zkCli.sh -server 127.0.0.1:2181
```
