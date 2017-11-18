# distribution_harbor_key角色
该角色需要先制作证书并部署完Harbor,只是简单的分发签署harbor的CA证书到服务器,并自动登陆</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)
# docker_compose角色
[官方github](https://github.com/docker/compose)
下载官方文件到roles/docker_compose/files/main_program</br>
这是Harbor前置准备</br>
# Harbor角色
[官方github](https://github.com/vmware/harbor)
下载官方离线包到roles/harbor/files/main_program</br>
执行这个角色只是进行前期准备,最终安装需要手动执行</br>
模板根据实际情况自行调整,默认定义了ssl密钥,服务器默认为部署节点的IP地址,协议使用https</br>
###### [关于证书定义](https://github.com/uufengfeng/Ansible_Script_null/tree/master/cfssl)
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
登陆harbor
```sh
$ docker login 10.100.57.58
```
认证信息会自动保存到~/.docker/config.json</br>
也可通过distribution_harbor_key 角色来完成分发CA证书和登陆</br>
## 3.其它操作
停止harbor
```sh
$ docker-compose down -v
```
修改配置并更新
```sh
vim harbor.cfg
./prepare
```
启动harbor
```sh
docker-compose up -d
```

ssh\_keygen Roles
需要ansible hosts文件,定义inventory变量<br />
示例在inventory目录,ssh\_keygen文件<br />
ssh\_keygen\_private变量为yes,向目标推送私钥<br />
ssh\_keygen\_pub变量为yes,向目标推送公钥<br />

生成密钥用于roles ssh\_keygen
ssh-keygen -t rsa -f ../roles/ssh\_keygen/files/id\_rsa<br />
note:
密钥要生成在roles/ssh\_keygen/files目录下<br />
