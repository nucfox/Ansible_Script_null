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
&emsp;ansible安装需要为host定义inventory变量zoo_my_id,以区分myid  
###### ini格式
```
[zookeeper]
192.168.1.1 zoo_my_id=1
192.168.1.2 zoo_my_id=2
192.168.1.3 zoo_my_id=3
```
###### yml格式

```
all:
  children:
    zookeeper:
      hosts:
        192.168.1.1:
          zoo_my_id: 1
        192.168.1.2:
          zoo_my_id: 2
        192.168.1.3:
          zoo_my_id: 3
```
##### [zookeeper 4字命令](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_zkCommands)  
---
ZooKeeper 四字命令 | 功能描述
---|---
conf | 输出相关服务配置的详细信息
cons | 列出所有连接到服务器的客户端的完全的连接/ 会话的详细信息.包括"接受/发送"的包数量,会话 id ,操作延迟,最后的操作执行等等信息
dump|列出未经处理的会话和临时节点
envi|输出关于服务环境的详细信息(区别于 conf 命令)
reqs|列出未经处理的请求
ruok|测试服务是否处于正确状态.如果确实如此,那么服务返回"imok",否则不做任何相应
stat|输出关于性能和连接的客户端的列表
wchs|列出服务器 watch 的详细信息
wchc|通过 session 列出服务器 watch 的详细信息,它的输出是一个与 watch 相关的会话的列表
wchp|通过路径列出服务器 watch 的详细信息.它输出一个与 session 相关的路径

---
##### [zookeeper客服端命令](https://zookeeper.apache.org/doc/current/zookeeperStarted.html#sc_ConnectingToZooKeeper) 

```
#进入docker容器
bash-4.4# ./bin/zkCli.sh -server 127.0.0.1:2181
```

---

命令 |格式 |说明
---|---|---
help | |查询客户端支持的命令
connect |connect host:port |连接zk服务器,与close命令配合可以连接或断开zk服务器
close||关闭与服务器链接
create|create [-s] [-e] path data acl|创建节点 -s为顺序节点(自动给节点后添加一串数字以作区分),-e为临时节点(断开会话后自动删除),不指定为永久节点,acl进行权限控制,不指定为world:anyone:cdrwa,如create /test hello
delete|delete path [version]|删除节点,如delete /test
get|get path [watch]|获取节点信息,节点路径必须以/开头的绝对路径,如get /test
stat|stat path [watch]|查看节点状态信息,如stat /test,只有状态信息,没有节点的值
addauth|addauth scheme auth|节点认证,如addauth digest username:password
getAcl|getAcl path|获取节点的Acl, 如getAcl /test
setAcl|setAcl path acl|用于设置节点Acl,Acl由三部分构成:1为scheme,2为user,3为permission,一般情况下表示为scheme:id:permissions
set|set path data [version]|设置节点的值,如 set /test hellotest
history||列出历史命令,配合redo使用
redo|redo cmdno|history列出历史命令编号,redo 10
listquota|listquota path|显示配额
setquota|setquota -n\|-b val path|设置节点个数以及数据长度的配额,-n子节点个数,-n节点长度
delquota|delquota [-n\|-b] path|删除配额,-n子节点个数,-b节点数据长度
sync|sync path|用于强制同步,由于请求在半数以上的zk server上生效就表示此请求生效,那么就会有一些zk server上的数据是旧的.sync命令就是强制同步所有的更新操作
printwatches|printwatches on\|off|用于设置和显示监视状态，值为on或则off
ls |ls path [watch]|获取路径下的节点信息
ls2 | ls2 path [watch]|ls命令的增强版,比ls命令多输出本节点信息
---

Acl权限说明  
scheme | id
---|----
world | 只有一个id,叫anyone,world:anyone代表任何人,zookeeper中对所有人有权限的节点就是属于world:anyone的
auth | 不需要id,只要是通过authentication的user都有权限(zookeeper支持通过kerberos来进行authencation,也支持username/password形式的authentication)
digest|id为username:BASE64(SHA1(password),需要先通过username:password形式的authentication
ip|id为客户机的IP地址，设置的时候可以设置一个ip段,比如ip:192.168.1.0/16,表示匹配前16个bit的IP段
super|在这种scheme情况下，对应的id拥有超级权限，可以做任何事情(cdrwa)
---
permissions  
权限 | 说明
---|---
CREATE(c) | 创建权限，可以在在当前node下创建child node
DELETE(d) | 删除权限，可以删除当前的node
READ(r) | 读权限，可以获取当前node的数据，可以list当前node所有的child nodes
WRITE(w) | 写权限，可以向当前node写数据
ADMIN(a) | 管理权限，可以设置当前node的permission
---