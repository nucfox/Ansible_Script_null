# 注意ca证书不要多次生成,否则ca签名的其它证书会失效
# ca-config.json
  CA 是自签名的证书,用来签名后续创建的其它 TLS 证书</br>
* ca-config.json: 可以定义多个 profiles，分别指定不同的过期时间,使用场景等参数;后续在签名证书时使用某个 profile
* signing: 表示该证书可用于签名其它证书；生成的 ca.pem 证书中CA=TRUE
* server auth: 表示 client 可以用该 CA 对 server 提供的证书进行验证
* client auth: 表示 server 可以用该 CA 对 client 提供的证书进行验证
# ca-csr.json
* "CN": Common Name, kube-apiserver 从证书中提取该字段作为请求的用户名 (User Name); 浏览器使用该字段验证网站是否合法
* "O": Organization, kube-apiserver 从证书中提取该字段作为请求用户所属的组 (Group)
# etcd-csr.json
  保证通信安全，客户端(如 etcdctl) 与 etcd 集群、etcd 集群之间的通信需要使用 TLS 加密，创建 etcd TLS 加密所需的证书和私钥</br>
* hosts 字段指定授权使用该证书的 etcd 节点 IP
# admin-csr.json
  kubectl 与 kube-apiserver 的安全端口通信，需要为安全通信提供 TLS 证书和秘钥</br>
* 后续 kube-apiserver 使用 RBAC 对客户端(如 kubelet,kubeproxy,Pod)请求进行授权;
* kube-apiserver 预定义了一些 RBAC 使用的 RoleBindings,如cluster-admin 将 Group system:masters 与 Role cluster-admin 绑定,该 Role 授予了调用 kube-apiserver 所有 API的权限
* O 指定该证书的 Group 为 system:masters,kubelet 使用该证书访问kube-apiserver 时,由于证书被 CA 签名,所以认证通过,同时由于证书用户组为经过预授权的 system:masters,所以被授予访问所有 API 的权限
* hosts 属性值为空列表
# flanneld-csr.json
  etcd 集群启用了双向 TLS 认证,所以需要为 flanneld 指定与 etcd 集群通信的 CA 和秘钥</br>
* hosts 字段为空
# kubernetes-csr.json
* 如果 hosts 字段不为空则需要指定授权使用该证书的 IP 或域名列表，所以分别指定了当前部署的 master 节点主机 IP
* 还需要添加 kube-apiserver 注册的名为 kubernetes 的服务 IP (Service Cluster IP),一般是 kube-apiserver --service-cluster-ip-range 选项值指定的网段的第一个IP，如 "10.254.0.1"
# kube-proxy-csr.json
* CN 指定该证书的 User 为 system:kube-proxy
* kube-apiserver 预定义的 RoleBinding system:node-proxier 将User system:kube-proxy 与 Role system:node-proxier 绑定,该 Role 授予了调用 kube-apiserver Proxy 相关 API 的权限
* hosts 属性值为空列表
# harbor-csr.json
* hosts 字段指定授权使用该证书的当前部署节点 IP,如果后续使用域名访问harbor则还需要添加域名
# 生成证书
可以执行cg-ca.sh脚本,也可使用命令生成,生成的脚本需要复制到相应角色目录下,请参考使用到证书的角色说明</br>

