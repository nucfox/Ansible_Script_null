模拟环境
4台服务器
10.100.57.54
10.100.57.56
10.100.57.57
10.100.57.60

3个mon,3个osd

更改服务器hostname,hosts
10.100.57.54 node1
10.100.57.56 node2
10.100.57.57 node3
10.100.57.60 deploy-node

创建ceph用户

node1 安装 osd
node2 安装 mon osd
node3 安装 mon osd
deploy-node 安装 mon ceph-deploy

在deploy-node 做免密钥登陆设置
设置ssh\_config StrictHostKeyChecking no
设置ceph用户.ssh/config添加
<pre><code>
Host deploy-node
   Hostname deploy-node
   User ceph
Host node1
   Hostname node1
   User ceph
Host node2
   Hostname node2
   User ceph
Host node3
   Hostname node3
   User ceph
</code></pre>

在deploy-node上安装ceph-deploy

以上初始化可以在roles/{ssh\_keygen,edit\_hosts,ceph}设置

切换ceph用户
创建目录,名字随意 ceph-cluster
在ceph-cluster目录下操作

如果安装过ceph,进行一下命令清理环境
ceph-deploy purgedata deploy-node node1 node2 node3
ceph-deploy purge deploy-node node1 node2 node3
ceph-deploy forgetkeys


创建ceph集群
ceph-deploy new deploy-node node2 node3

生成ceph.conf,ceph.mon.keyring

修改ceph.conf
添加
osd pool default size = 3   #副本数
rbd\_default\_features = 1  #仅是layering对应的bit码所对应的整数值

ceph-deploy install deploy-node node1 node2 node3
ceph-deploy通过ssh登陆个服务器安装ceph组件

初始化ceph monitor node
ceph-deploy mon create-initial
默认会读取ceph.conf的mon\_initial\_members = deploy-node node2 node3初始化mon,选举,生成key.
PS:选举超时会自动退出

生成完毕,会看到若干个key,ceph组件进行安全访问所需要
<pre><code>
ceph.bootstrap-mds.keyring
ceph.bootstrap-mgr.keyring
ceph.bootstrap-osd.keyring
ceph.bootstrap-rgw.keyring
ceph.client.admin.keyring
</code></pre>

mon组件安装完毕

安装OSD
模拟osd环境
在需要安装osd的3个服务器,创建20G文件/u06/dev/ceph{0,1,2}格式化为xfs
同时3个服务器分别创建/u06/dev/ceph/osd/ceph-osd{0,1,2}
并挂载mount /u06/dev/ceph0 /u06/dev/ceph/osd/ceph-osd0
mount -o remount,user\_xatte /u06/dev/ceph/osd/ceph-osd0
修改fstab添加开机自动挂载

准备osd
ceph-deploy osd prepare node1:/u06/dev/ceph/osd/ceph-osd0
ceph-deploy osd prepare node2:/u06/dev/ceph/osd/ceph-osd1
ceph-deploy osd prepare node3:/u06/dev/ceph/osd/ceph-osd2

修改权限
chown -R ceph. /u06/dev/ceph

激活osd
ceph-deploy osd activate node1:/u06/dev/ceph/osd/ceph-osd0
ceph-deploy osd activate node2:/u06/dev/ceph/osd/ceph-osd1
ceph-deploy osd activate node3:/u06/dev/ceph/osd/ceph-osd2

同步keying到各个节点
ceph-deploy admin deploy-node node1 node2 node3


查看集群状态
<pre><code>
#sudo ceph osd tree
ID WEIGHT  TYPE NAME                   UP/DOWN REWEIGHT PRIMARY-AFFINITY 
-1 0.05806 root default                                                  
-2 0.01909     host exhibition-parse-2                                   
 0 0.01909         osd.0                    up  1.00000          1.00000 
-3 0.01949     host exhibition-parse-1                                   
 1 0.01949         osd.1                    up  1.00000          1.00000 
-4 0.01949     host exhibition-mysql-1                                   
 2 0.01949         osd.2                    up  1.00000          1.00000 
</code></pre>
<pre><code>
#sudo ceph -s
    cluster 15ad522a-1a3b-4d4a-bc62-828dcf5ffa56
     health HEALTH_OK
     monmap e1: 3 mons at {exhibition-parse-1=10.100.57.56:6789/0,exhibition-parse-2=10.100.57.57:6789/0,exhibition-web-2=10.100.57.60:6789/0}
            election epoch 6, quorum 0,1,2 exhibition-parse-1,exhibition-parse-2,exhibition-web-2
     osdmap e16: 3 osds: 3 up, 3 in
            flags sortbitwise,require_jewel_osds
      pgmap v86: 64 pgs, 1 pools, 14624 kB data, 16 objects
            15492 MB used, 45437 MB / 60930 MB avail
                  64 active+clean
</code></pre>

测试以ceph RBD为后端Volume的Pod
官方示例路径
https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/rbd

默认已经开启了安全验证cephx,所以使用rbd-with-secret.json和secret/ceph-secret.yaml

volumes部分是和ceph rbd紧密相关的一些信息，各个字段的大致含义如下:

name:volume名字,这个没什么可说的,顾名思义即可.
rbd.monitors:前面提到过ceph集群的monitor组件,这里填写monitor组件的通信信息,集群里有几个monitor就填几个;
rbd.pool:Ceph中的pool记号,它用来给ceph中存储的对象进行逻辑分区用的.默认的pool是"rbd";
rbd.image:Ceph磁盘块设备映像文件;
rbd.user:ceph client访问ceph storage cluster所使用的用户名.ceph有自己的一套user管理系统,user的写法通常是TYPE.ID,比如client.admin(是不是想到对应的文件:ceph.client.admin.keyring).client是一种type,而admin则是user.一般来说,Type基本都是client.
secret.Ref:引用的k8s secret对象名称

在rbd服务器上创建磁盘块设备映像文件
<pre><code>
#rbd create foo -s 1024
#rbd list
foo
</code></pre>
如果之前没有定义rbd\_default\_features = 1,可以在创建映像时指定只开启layering特性,应为3.10内核只支持layering特性

将foo image映射到内核
<pre><code>
rbd map foo
</code></pre>

获取client.admin的keyring值并用base64编码
<pre><code>
#ceph auth get-key client.admin
AQC52QtarsDZLBAAJHfTPnpumRX2Yx67/1Zg+A==
#echo "AQC52QtarsDZLBAAJHfTPnpumRX2Yx67/1Zg+A==" | base64
QVFDNTJRdGFyc0RaTEJBQUpIZlRQbnB1bVJYMll4NjcvMVpnK0E9PQo=
</code></pre>

修改ceph-secret.yaml文件,data下的key值
创建ceph-secret:
<pre><code>
#kubectl create -f ceph-secret.yaml
#kubectl get secret
</code></pre>

修改rbd-with-secret.json

创建
<pre><code>
#kubectl create -f rbd-with-secret.json
</code></pre>

可以到pod被调度到的node上查看信息
<pre><code>
#rbd showmapped

#mount
... ...
/dev/rbd0 on /var/lib/kubelet/plugins/kubernetes.io/rbd/rbd/rbd-image-foo type xfs (rw)
</code></pre>


k8s pv和pvc 持久化存储
创建一个1G映像作为测试
<pre><code>
#rbd create ceph-image -s 1024
#rbd info ceph-image
</code></pre>

修改pv和pvc并创建
kubectl create -f ceph-pv.yaml
kubectl create -f ceph-pvc.yaml
创建测试用的pod
kubectl create -f ceph-pod1.yaml

测试持久化
kubectl exec ceph-pod1 -it touch /usr/share/busybox/hello-ceph.txt
kubectl exec ceph-pod1 -it vi /usr/share/busybox/hello-ceph.txt
kubectl exec ceph-pod1 -it cat /usr/share/busybox/hello-ceph.txt

删除ceph-pod1
kubectl delete po ceph-pod1
创建ceph-pod2
kubectl create -f ceph-pod2.yaml
查看之前创建的文件
kubectl exec ceph-pod2 -it cat /usr/share/busybox/hello-ceph.txt
