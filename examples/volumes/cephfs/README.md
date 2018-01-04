创建和部署RBD一样,让ceph支持cephfs需要安装mds组件,通过RBD基础安装mds</br>
```sh
#ceph-deploy mds create deploy-node node2 node3
```
在节点上可以看到mds运行</br>
```sh
ps -ef | grep ceph-mds
```
  mds不负责实现任何数据的存储,而是依赖于RADOS本身</br>
  cephFS 的FS存在两类pool分别是Metadata pool和Data poll,所以可以使用CRUSH规则来为metada pool设置更快的存储,而data pool使用相对慢的存储.</br>
  CephFS 的元数据中每个目录会作为一个或者多个 Object 存储,类似 . 的命名方式。同时每个 inode 和 dentry 信息也会被内置其中，该类 Object 会被存储到 Metadata Pool 中.而文件实际数据也以类似的 . 存储到 Data Pool 中.同时还会像 XFS Log 一样存在 Log Object 存在于 Metadata Pool,是为了实现涉及多个 Object 的事务性操作准备,因为 RADOS 并不提供多对象的原子性.该 Log Object 包含了最近的所有元数据操作,在存在意外时可以使用 Log Object Replay 之前的数据.</br>
  对于一个刚创建的MDS服务,虽然服务是运行的,但是它的状态直到创建 pools 以及文件系统的时候才会变为Active</br>
  
  创建cephfs 存储池</br>
ceph osd pool create {pool-name} {pg-num} [{pgp-num}]</br>
    {pool-name}--> 存储池名称，必须唯一.</br>
    {pg-num}--> 存储池拥有的归置组总数.</br>
    {pgp-num}--> 用于归置的归置组总数.</br>
ceph osd pool create cephfs_data 10</br>
ceph osd pool create cephfs_metadata 10</br>
ceph fs new leadorfs  cephfs_metadata cephfs_data</br>
查看状态</br>
```sh
# ceph mds stat
e6: 1/1/1 up {0=exhibition-parse-1=up:active}, 2 up:standby
```
客户端挂载cephfs</br>
```sh
# yum install ceph-fuse -y
```
默认是开启认证的,所以要使用密钥挂载</br>
获取client.admin密钥</br>
```sh
# grep key /etc/ceph/ceph.client.admin.keyring | awk '{print $3}'
AQC52QtarsDZLBAAJHfTPnpumRX2Yx67/1Zg+A==
```
or
```sh
# ceph auth list 2> /dev/null | grep -A1 admin | grep key | awk '{print $2}'
```
挂载:</br>
这里的admin.secret文件是把得到的密钥写入到文件里,也可以直接填写密钥</br>
```sh
# mount.ceph exhibition-web-2:6789:/ /u06/cephfs1 -o name=admin,secretfile=/etc/ceph/admin.secret
```
or
```sh
# mount.ceph exhibition-web-2:6789:/ /u06/cephfs1 -o name=admin,secret=AQC52QtarsDZLBAAJHfTPnpumRX2Yx67/1Zg+A==
```
如有多个mon监控节点,可以同时过载多个,保证一个mon节点down不会影响数据写入</br>
```sh
# mount.ceph exhibition-parse-1,exhibition-parse-2,exhibition-web-2:6789:/ /u06/cephfs1 -o name=admin,secretfile=/etc/ceph/admin.secret
```
