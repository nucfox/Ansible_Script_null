#
官方EFK插件地址<br />
https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-elasticsearch<br />
<br />
#
##es-statefulset.yaml
vim编辑<br />
  %s/\_\_IMAGE\_\_elasticsearch\_\_/gcr.io\/google-containers\/elasticsearch:v5.6.2/g<br />
PS:<br />
  \_\_IMAGE\_\_elasticsearch\_\_  替换为  elasticsearch的docker镜像<br />
  如果gcr.io连不上<br />
  heapster-grafana-amd64  可以使用  uufengfeng\/elasticsearch:v5.6.2<br />

#
##fluentd-es-ds.yaml
vim编辑<br />
  %s/\_\_IMAGE\_\_fluentd\_\_elasticsearch\_\_/gcr.io\/google-containers\/fluentd-elasticsearch:v2.0.2/g<br />
PS:<br />
  \_\_IMAGE\_\_fluentd\_\_elasticsearch\_\_  替换为  fluentd-elasticsearch的docker镜像<br />
  如果gcr.io连不上<br />
  fluentd-elasticsearch  可以使用  uufengfeng\/fluentd-elasticsearch:v2.0.2<br />

#
##kibana-deployment.yaml
vim编辑<br />
  %s/\_\_IMAGE\_\_kibana\_\_/docker.elastic.co\/kibana\/kibana:5.6.2/g<br />
PS:<br />
  \_\_IMAGE\_\_kibana\_\_  替换为  kibana的docker镜像<br />
  如果gcr.io连不上<br />
  kibana  可以使用  uufengfeng\/kibana:5.6.2<br />

官方:<br />
 /api/v1/proxy/namespaces/kube-system/services/kibana-logging<br />
kube 1.7版要修改为<br />
 /api/v1/namespaces/kube-system/services/kibana-logging/proxy<br />


##fluentd TLS
编辑 fluentd-es-configmap.yaml<br />
<pre><code>
...
<filter kubernetes.**>
      type kubernetes_metadata
      ca_file /etc/kubernetes/ssl/ca.pem
      client_cert /etc/kubernetes/ssl/admin.pem
      client_key /etc/kubernetes/ssl/admin-key.pem
</filter>
...
</code></pre>
编辑 fluentd-es-ds.yaml 挂载ssl证书目录<br />
<pre><code>
...
  volumeMounts:
  ...
  - name: tls-files
  mountPath: /etc/kubernetes/ssl
...
volumes:
- name: tls-files
  hostPath:
    path: /etc/kubernetes/ssl
...
</pre></code>


kubectl create -f fluentd-es-configmap.yaml -n kube-system<br />
kubectl create -f fluentd-es-ds.yaml<br />


kubectl delete cm fluentd-es-config-v0.1.0 -n kube-system<br />
kubectl delete ClusterRole fluentd-es<br />
kubectl delete sa fluentd-es -n kube-system<br />
kubectl delete ClusterRoleBinding fluentd-es<br />
kubectl delete ds fluentd-es-v2.0.2 -n kube-system<br />

kubectl create -f es-service.yaml
kubectl create -f es-statefulset.yaml

kubectl delete svc,sa,clusterroles,clusterrolebindings,statefulsets elasticsearch-logging -n kube-system
