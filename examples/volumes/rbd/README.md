模拟环境</br>
4台服务器</br>
10.100.57.54</br>
10.100.57.56</br>
10.100.57.57</br>
10.100.57.60</br>

3个mon,3个osd</br>

更改服务器hostname,hosts</br>
10.100.57.54 node1</br>
10.100.57.56 node2</br>
10.100.57.57 node3</br>
10.100.57.60 deploy-node</br>

创建ceph用户</br>

node1 安装 osd</br>
node2 安装 mon osd</br>
node3 安装 mon osd</br>
deploy-node 安装 mon ceph-deploy</br>

在deploy-node 做免密钥登陆设置</br>
设置ssh\_config StrictHostKeyChecking no</br>
设置ceph用户.ssh/config添加</br>
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

在deploy-node上安装ceph-deploy</br>

以上初始化可以在roles/{ssh\_keygen,edit\_hosts,ceph}设置</br>

切换ceph用户</br>
创建目录,名字随意 ceph-cluster</br>
在ceph-cluster目录下操作</br>

如果安装过ceph,进行一下命令清理环境</br>
ceph-deploy purgedata deploy-node node1 node2 node3</br>
ceph-deploy purge deploy-node node1 node2 node3</br>
ceph-deploy forgetkeys</br>


创建ceph集群</br>
ceph-deploy new deploy-node node2 node3</br>

生成ceph.conf,ceph.mon.keyring</br>

修改ceph.conf</br>
添加</br>
osd pool default size = 3   #副本数</br>
rbd\_default\_features = 1  #仅是layering对应的bit码所对应的整数值</br>

ceph-deploy install deploy-node node1 node2 node3</br>
ceph-deploy通过ssh登陆个服务器安装ceph组件</br>
PS:安装ceph组件时,只要使用ceph功能的服务器都要安装组件,install后的服务器不局限于部署服务器,根据实际情况调整</br>

初始化ceph monitor node</br>
ceph-deploy mon create-initial</br>
默认会读取ceph.conf的mon\_initial\_members = deploy-node node2 node3初始化mon,选举,生成key.</br>
PS:选举超时会自动退出</br>

生成完毕,会看到若干个key,ceph组件进行安全访问所需要</br>
<pre><code>
ceph.bootstrap-mds.keyring
ceph.bootstrap-mgr.keyring
ceph.bootstrap-osd.keyring
ceph.bootstrap-rgw.keyring
ceph.client.admin.keyring
</code></pre>

mon组件安装完毕</br>

安装OSD</br>
模拟osd环境</br>
在需要安装osd的3个服务器,创建20G文件/u06/dev/ceph{0,1,2}格式化为xfs</br>
同时3个服务器分别创建/u06/dev/ceph/osd/ceph-osd{0,1,2}</br>
并挂载mount /u06/dev/ceph0 /u06/dev/ceph/osd/ceph-osd0</br>
mount -o remount,user\_xatte /u06/dev/ceph/osd/ceph-osd0</br>
修改fstab添加开机自动挂载</br>

准备osd</br>
ceph-deploy osd prepare node1:/u06/dev/ceph/osd/ceph-osd0</br>
ceph-deploy osd prepare node2:/u06/dev/ceph/osd/ceph-osd1</br>
ceph-deploy osd prepare node3:/u06/dev/ceph/osd/ceph-osd2</br>

修改权限</br>
chown -R ceph. /u06/dev/ceph</br>

激活osd</br>
ceph-deploy osd activate node1:/u06/dev/ceph/osd/ceph-osd0</br>
ceph-deploy osd activate node2:/u06/dev/ceph/osd/ceph-osd1</br>
ceph-deploy osd activate node3:/u06/dev/ceph/osd/ceph-osd2</br>

同步keying到各个节点</br>
ceph-deploy admin deploy-node node1 node2 node3</br>


查看集群状态</br>
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

测试以ceph RBD为后端Volume的Pod</br>
官方示例路径</br>
https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/rbd</br>

默认已经开启了安全验证cephx,所以使用rbd-with-secret.json和secret/ceph-secret.yaml</br>

volumes部分是和ceph rbd紧密相关的一些信息，各个字段的大致含义如下:</br>

name:volume名字,这个没什么可说的,顾名思义即可.</br>
rbd.monitors:前面提到过ceph集群的monitor组件,这里填写monitor组件的通信信息,集群里有几个monitor就填几个;</br>
rbd.pool:Ceph中的pool记号,它用来给ceph中存储的对象进行逻辑分区用的.默认的pool是"rbd";</br>
rbd.image:Ceph磁盘块设备映像文件;</br>
rbd.user:ceph client访问ceph storage cluster所使用的用户名.ceph有自己的一套user管理系统,user的写法通常是TYPE.ID,比如client.admin(是不是想到对应的文件:ceph.client.admin.keyring).client是一种type,而admin则是user.一般来说,Type基本都是client.</br>
secret.Ref:引用的k8s secret对象名称</br>

在rbd服务器上创建磁盘块设备映像文件</br>
<pre><code>
#rbd create foo -s 1024
#rbd list
foo
</code></pre>
如果之前没有定义rbd\_default\_features = 1,可以在创建映像时指定只开启layering特性,因为3.10内核只支持layering特性</br>

将foo image映射到内核</br>
<pre><code>
rbd map foo
</code></pre>

获取client.admin的keyring值并用base64编码</br>
<pre><code>
#ceph auth get-key client.admin
AQC52QtarsDZLBAAJHfTPnpumRX2Yx67/1Zg+A==
#echo "AQC52QtarsDZLBAAJHfTPnpumRX2Yx67/1Zg+A==" | base64
QVFDNTJRdGFyc0RaTEJBQUpIZlRQbnB1bVJYMll4NjcvMVpnK0E9PQo=
</code></pre>

修改ceph-secret.yaml文件,data下的key值</br>
创建ceph-secret:</br>
<pre><code>
#kubectl create -f ceph-secret.yaml
#kubectl get secret
</code></pre>

修改rbd-with-secret.json</br>

创建</br>
<pre><code>
#kubectl create -f rbd-with-secret.json
</code></pre>

可以到pod被调度到的node上查看信息</br>
<pre><code>
#rbd showmapped

#mount
... ...
/dev/rbd0 on /var/lib/kubelet/plugins/kubernetes.io/rbd/rbd/rbd-image-foo type xfs (rw)
</code></pre>


k8s pv和pvc 持久化存储</br>
创建一个1G映像作为测试</br>
<pre><code>
#rbd create ceph-image -s 1024
#rbd info ceph-image
</code></pre>

修改pv和pvc并创建</br>
kubectl create -f ceph-pv.yaml</br>
kubectl create -f ceph-pvc.yaml</br>
创建测试用的pod</br>
kubectl create -f ceph-pod1.yaml</br>

测试持久化</br>
kubectl exec ceph-pod1 -it touch /usr/share/busybox/hello-ceph.txt</br>
kubectl exec ceph-pod1 -it vi /usr/share/busybox/hello-ceph.txt</br>
kubectl exec ceph-pod1 -it cat /usr/share/busybox/hello-ceph.txt</br>

删除ceph-pod1</br>
kubectl delete po ceph-pod1</br>
创建ceph-pod2</br>
kubectl create -f ceph-pod2.yaml</br>
查看之前创建的文件</br>
kubectl exec ceph-pod2 -it cat /usr/share/busybox/hello-ceph.txt</br>
