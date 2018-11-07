
参数 | conf文件变量 |默认值| 解释
---|---|---|---
----|成员配置|----
--name | ETCD_NAME |'default'| 集群中的节点名,可区分且不重复就行
--data-dir | ETCD_DATA_DIR |'${name}.etcd'| 数据存放位置,这些数据包括节点ID，集群ID，集群初始化配置，Snapshot文件，若未指定--wal-dir，还会存储WAL文件
--wal-dir|ETCD_WAL_DIR|''|指向专用WAL目录的路径
--listen-peer-urls|ETCD_LISTEN_PEER_URLS|'http://localhost:2380'|监听的用于节点之间通信的url,可监听多个，集群内部将通过这些url进行数据交互(如选举，数据同步等)
--listen-client-urls|ETCD_LISTEN_CLIENT_URLS|'http://localhost:2379'|监听的用于客户端通信的url,同样可以监听多个
--snapshot-count|ETCD_SNAPSHOT_COUNT|10000|触发快照动作到磁盘的事务递交次数
--max-snapshots|ETCD_MAX_SNAPSHOTS|5|保留的快照文件的最大数量
--max-wals|ETCD_MAX_WALS|5|保留的wal文件的最大数量
----|集群配置|----
--initial-advertise-peer-urls|ETCD_INITIAL_ADVERTISE_PEER_URLS|'http://localhost:2380'|建议用于节点之间通信的url，节点间将以该值进行通信
--initial-cluster|ETCD_INITIAL_CLUSTER|'default=http://localhost:2380'|初始化集群内节点地址,也就是集群中所有的initial-advertise-peer-urls的合集
--initial-cluster-state|ETCD_INITIAL_CLUSTER_STATE|'new|新建集群的标志,初始化状态使用new,建立之后改此值为 existing
--initial-cluster-token|ETCD_INITIAL_CLUSTER_TOKEN|'etcd-cluster'|节点的token值,设置该值后集群将生成唯一id,并为每个节点也生成唯一id,当使用相同配置文件再启动一个集群时,只要该token值不一样,etcd集群就不会相互影响
--advertise-client-urls|ETCD_ADVERTISE_CLIENT_URLS|'http://localhost:2379'|建议使用的客户端通信url,该值用于etcd代理或etcd成员与etcd节点通信
----|客户端到服务器通信|----
--cert-file|ETCD_CERT_FILE|''|用于与etcd的SSL/TLS连接的证书.设置此选项时,advertise-client-urls可以使用HTTPS模式
--key-file|ETCD_KEY_FILE|''|证书的密钥,必须未加密
--client-cert-auth|ETCD_CLIENT_CERT_AUTH|'false'|设置此选项后,etcd将检查所有来自受信任CA签署的客户端证书的传入HTTPS请求,因此不提供有效客户端证书的请求将失败
--trusted-ca-file|ETCD_TRUSTED_CA_FILE|''|受信任的证书颁发机构
--auto-tls|ETCD_AUTO_TLS|'false'|对客户端的TLS连接使用自动生成的自签名证书
----|对等（服务器到服务器/集群）通信|----
--peer-cert-file|ETCD_PEER_CERT_FILE|''|用于对等体之间SSL/TLS连接的证书.这将用于侦听对等体地址以及向其他对等体发送请求
--peer-key-file|ETCD_PEER_KEY_FILE|''|证书的密钥,必须未加密
--peer-client-cert-auth|ETCD_PEER_CLIENT_CERT_AUTH|'false'|设置时,etcd将检查来自集群的所有传入对等请求,以获得由提供的CA签名的有效客户端证书
--peer-trusted-ca-file|ETCD_PEER_TRUSTED_CA_FILE|''|受信任的证书颁发机构
--peer-auto-tls|ETCD_PEER_AUTO_TLS|'false'|对对等体之间的TLS连接使用自动生成的自签名证书
---
#### [SNAPSHOT](https://zhuanlan.zhihu.com/p/29865583)  
**简介**  
&emsp;etcd-raft中的snapshot,主要是为了回收日志占用的存储空间(包括内存和磁盘)   
&emsp;日志在集群节点之间进行状态同步:客户的所有更新首先都会被转化为更新日志,顺序追加在日志文件中,日志文件中的内容会在集群节点之间进行顺序同步以维持节点之间的状态一致,只有写入集群多数节点的日志项才被允许更改应用的状态机  
&emsp;随着系统运行,日志文件一直追加会导致容量的增长.因此,需要特定的机制来回收那些无用的日志数据  
&emsp;etcd-raft中的snapshot代表了应用的状态数据,而执行snapshot的动作也就是将应用状态数据持久化存储,这样,在该snapshot之前的所有日志便成为无效数据,可以删除  
---
#### [日志管理](https://zhuanlan.zhihu.com/p/29692778)
**简介**  
&emsp;日志是实现一致性协议的最重要手段.客户对应用发起的状态更新请求首先都会被记录在日志中,待主节点将更新日志在集群多数节点之间完成同步以后,便将该日志项内容在状态机中进行应用,进而便完成了一次客户的更新请求  
---
#### [WAL](https://my.oschina.net/fileoptions/blog/1825531)  
**简介**  
&emsp;WAL是write ahead log的缩写,顾名思义,也就是在执行真正的写操作之前先写一个日志,可以类比redo log,和它相对的是WBL(write behind log),这些日志都会严格保证持久化,以保证整个操作的一致性和可恢复性  
---

#### playbook安装  
##### &emsp;etcd角色 
&emsp;inventory变量需要设置NODE_NAME变量,用于定义每个节点的名称  
###### example:  
```
[etcd_cluster]
10.100.57.54 ansible_ssh_user=root ansible_ssh_pass=*  NODE_NAME=etcd-host0
10.100.57.55 ansible_ssh_user=root ansible_ssh_pass=*  NODE_NAME=etcd-host1
10.100.57.56 ansible_ssh_user=root ansible_ssh_pass=*  NODE_NAME=etcd-host2
```
&emsp;playbook变量ETCD_NODES,参数为--initial-cluster,要与NODE_NAME变量对应,参数为--name
```
ETCD_NODES: etcd-host0=https://10.100.57.54:2380,etcd-host1=https://10.100.57.55:2380,etcd-host2=https://10.100.57.56:2380
```
读取变量的位置  
etcd.yml  
global_vars/kubernetes.yml  
roles/etcd/vars/main.yml  
roles/etcd/defaults/main.yml  
---
#### [ETCDCTL使用](https://coreos.com/etcd/docs/latest/demo.html#get-by-prefix)  
[参考文献](http://www.infoq.com/cn/articles/etcd-interpretation-application-scenario-implement-principle/)  
&emsp;ETCDCTL全局变量ETCDCTL_API没有设置情况下,API为v2版本
以下均采用v3版本
```
[root@example ~]# ETCDCTL_API=3 etcdctl version
```
&emsp;如果开启TLS认证,需设置证书
```
[root@example ~]# ETCDCTL_API=3 etcdctl \
--cacert=/etc/ssl/kubernetes/ca.pem \
--cert=/etc/ssl/etcd/etcd.pem \
--key=/etc/ssl/etcd/etcd-key.pem
或写入~/.bashrc
alias etcdctl='ETCDCTL_API=3 etcdctl --cacert=/etc/ssl/kubernetes/ca.pem --cert=/etc/ssl/etcd/etcd.pem --key=/etc/ssl/etcd/etcd-key.pem'
```
&emsp;以下命令均是设置了alias
```
指定集群信息
HOST_1=192.168.1.193
HOST_2=192.168.1.6
HOST_3=192.168.1.151
ENDPOINTS=$HOST_1:2379,$HOST_2:2379,$HOST_3:2379
```
##### 集群状态
```
[root@example ~]# etcdctl --endpoints=$ENDPOINTS --write-out=table endpoint status
```
ENDPOINT|ID|VERSION|DB SIZE|IS LEADER|RAFT TERM|RAFT INDEX
---|---|---|---|---|---|---
https://192.168.1.193:2379|f45a2f696b57fc70|3.3.10|20 kB|false|3|20
https://192.168.1.6:2379|50264fb9dee4eeea|3.3.10|20 kB|false|3|20
https://192.168.1.151:2379|2d0c43c9eefddd69|3.3.10|20 kB|true|3|20
```
[root@example ~]# etcdctl --endpoints=$ENDPOINTS --write-out=table endpoint health
https://192.168.1.193:2379 is healthy: successfully committed proposal: took = 3.748913ms
https://192.168.1.151:2379 is healthy: successfully committed proposal: took = 1.001375ms
https://192.168.1.6:2379 is healthy: successfully committed proposal: took = 1.347646ms
```
##### 集群成员
    集群成员相关命令
    member add	Adds a member into the cluster
	member remove	Removes a member from the cluster
	member update	Updates a member in the cluster
	member list	Lists all members in the cluster
```
列出成员信息
[root@example ~]# etcdctl --endpoints=$ENDPOINTS --write-out=table member list
```
ID|STATUS|NAME|PEER ADDRS|CLIENT ADDRS
-|-|-|-|-
2d0c43c9eefddd69|started|etcd-host2| https://192.168.1.151:2380|https://192.168.1.151:2379 
50264fb9dee4eeea|started|etcd-host1|   https://192.168.1.6:2380|https://192.168.1.6:2379
f45a2f696b57fc70|started|etcd-host0| https://192.168.1.193:2380|https://192.168.1.193:2379
##### 增
```
etcdctl --endpoints=$ENDPOINTS put foo "Hello World"
```
##### 查
```
etcdctl --endpoints=$ENDPOINTS get foo
etcdctl --endpoints=$ENDPOINTS -w json get foo

#Get by prefix
etcdctl --endpoints=$ENDPOINTS put web1 value1
etcdctl --endpoints=$ENDPOINTS put web2 value2
etcdctl --endpoints=$ENDPOINTS put web3 value3

etcdctl --endpoints=$ENDPOINTS get web --prefix
```
##### 删
```
etcdctl --endpoints=$ENDPOINTS put key myvalue
etcdctl --endpoints=$ENDPOINTS del key

etcdctl --endpoints=$ENDPOINTS put k1 value1
etcdctl --endpoints=$ENDPOINTS put k2 value2
etcdctl --endpoints=$ENDPOINTS del k --prefix
```
##### 快照
```
获取数据快照
etcdctl --endpoints=$ENDPOINTS snapshot save snapshot.db
```

```
还原快照
etcdctl snapshot restore snapshot.db --data-dir=/var/lib/etcd
快照还原的目录不能存在,报错提示
Error: data-dir "/var/lib/etcd" exists
可以指定到别的目录,还原之后设置好权限,停止etcd然后拷贝
```

##### 参考
[TLS](https://coreos.com/etcd/docs/latest/op-guide/security.html)  
&emsp;讲解TLS认证,包括自动发现带TLS，curl使用TLS访问etcd api
