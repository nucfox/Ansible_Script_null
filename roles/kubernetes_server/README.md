# k8s服务端便令说明
* kube_user 定义创建用户的用户名
* kube_path 定义server端的执行文件存放位置
* source_path 定义压缩包拷贝位置
* config_path 定义server端的配置文件存放位置
* log_path 定义log存放位置
* ca_ssl_path 定义ca证书存放位置
* kube_ssl_path 定义server端证书存放位置
* MASTER_IP 定义master部署节点IP
* ETCD_ENDPOINTS 定义ETCD集群地址
* SERVICE_CIDR 定义Service Cluster IP 地址段,该地址段不能路由可达
* NODE_PORT_RANGE 定义 NodePort 的端口范围
* BOOTSTRAP_TOKEN 定义首次启动请求值token
* CLUSTER_NAME 定义集群实例前缀(default "kubernetes")
* CLUSTER_CIDR 定义Cluster 中 Pod 的 CIDR 范围,该网段在各 Node 间必须路由可达(flanneld保证)
