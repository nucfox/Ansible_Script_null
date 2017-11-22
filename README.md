# distribution_harbor_key角色
该角色需要先制作证书并部署完Harbor,只是简单的分发签署harbor的CA证书到服务器,并自动登陆</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)
# docker_compose角色
[官方github](https://github.com/docker/compose)</br>
下载官方文件到roles/docker_compose/files/main_program</br>
这是Harbor前置准备</br>
# Harbor角色
[官方github](https://github.com/vmware/harbor)</br>
下载官方离线包到roles/harbor/files/main_program</br>
执行这个角色只是进行前期准备,最终安装需要手动执行</br>
模板根据实际情况自行调整,默认定义了ssl密钥,服务器默认为部署节点的IP地址,协议使用https</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)
###### [关于k8s使用私有库](https://github.com/uufengfeng/Ansible_Script_null/tree/master/examples/harbor)</br>
## 1.安装
* 进入解压的harbor目录
* 导入离线安装包
```sh
$ docker load -i harbor.v1.2.2.tar.gz
```
* 加载并启动harbor
```sh
$ ./install.sh
```
浏览器访问<code>https://node_ip</code></br>
账户默认admin,密码为harbor.cfg配置文件默认定义 Harbor12345</br>
日志目录默认 /var/log/harbor</br>
数据目录默认 /data 包括数据库,镜像仓库</br>
## 2.docker客户端登陆
将签署harbor的CA证书拷贝到/etc/docker/certs.d/${node_ip} 目录</br>
node_ip为部署服务器的IP</br>
```sh
$ cp /etc/kubernetes/ssl/ca.pem /etc/docker/certs.d/10.100.57.58/ca.crt
```
登陆harbor</br>
```sh
$ docker login 10.100.57.58
```
认证信息会自动保存到~/.docker/config.json</br>
也可通过distribution_harbor_key 角色来完成分发CA证书和登陆</br>
## 3.其它操作
停止harbor</br>
```sh
$ docker-compose down -v
```
修改配置并更新</br>
```sh
vim harbor.cfg
./prepare
```
启动harbor</br>
```sh
docker-compose up -d
```
# ssh_keygen角色
帮助完成服务器之间的免密登录</br>
需要定义ansible hosts文件,定义inventory变量</br>
示例在inventory目录,ssh_keygen文件</br>
ssh_keygen_private变量为yes,向目标推送私钥</br>
ssh_keygen_pub变量为yes,向目标推送公钥</br>
生成密钥用于roles ssh_keygen</br>
```sh
ssh-keygen -t rsa -f ../roles/ssh_keygen/files/id_rsa
```
密钥要生成在roles/ssh_keygen/files目录下</br>
# edit_hosts角色
通过读取制作完成hosts文件,写入指定的服务器/etc/hosts</br>
制作的hosts文件需要放入files/hosts_file/</br>
指定变量hostsfile_name,来读取文件内容,默认值defaults</br>
# docker-ce角色
该角色会卸载之前安装的旧版docker,并安装指定版本的docker-ce</br>
查询docker-ce版本</br>
```sh
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum list docker-ce --showduplicates | sort -r
```
定义DOCKER_VERSION变量,来指定版本</br>
默认:</br>
DOCKER_VERSION: docker-ce-17.06.1.ce</br>
如果FI: 0会强制安装,设为1 检测到安装了docker会停止安装</br>
# etcd角色
配合k8s安装,证书需提前设置,脚本制作的安装版本为3.2.6</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)</br>
# flannel角色
配合k8s安装,证书需提前设置,脚本制作的安装版本为0.9.0</br>
delegation_etcd变量解释,指定etcd集群中的一台来执行flannel网络配置</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)</br>
# kubernetes_server角色
需要提前安装etcd,flannel,脚本制作的安装版本为1.8</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)</br>
# kubernetes_node角色
需要提前安装etcd,flannel,脚本制作的安装版本为1.8</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)</br>
# kubernetes_client角色
脚本制作的安装版本为1.8</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)</br>
# ceph角色
只安装ceph-deploy部署工具,指定一台服务器做为部署节点,并设置部署节点</br>
需要提前设置部署节点到其它节点的免密登陆,各个节点的hostname,hosts文件</br>
* 该角色已经导入ssh_keygen角色,免密用户自动设置ceph用户,设置请参考ssh_keygen</br>
* 该角色已经导入edit_hosts角色,导入的hosts文件为ceph文件内容,设置请参考edit_hosts</br>
* 角色自动创建ceph用户(可以通过变量指定),并设置ceph用户的sudoer,免密使用sudo</br>
* 配置ceph的.ssh/config 免去ceph-deploy部署时ssh指定username,和/etc/ssh/ssh_config面known_hosts认证(需提前设置files/ssh_config/config和files/ssh_config/ssh_config)</br>
[安装请查看examples/volumes/rbd/README.md](https://github.com/uufengfeng/Ansible_Script_null/tree/master/examples/volumes/rbd)</br>
