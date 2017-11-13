#
官方heapster插件地址<br />
https://github.com/kubernetes/heapster/releases/latest<br />
#
官方文件目录： heapster-1.4.3/deploy/kube-config/influxdb<br />
heapster-rbac.yaml文档 heapster-1.4.3/deploy/kube-config/rbac<br />
#
#grafana.yaml<br />
vim编辑<br />
  %s/\_\_IMAGE\_\_heapster\_\_grafana\_\_/gcr.io\/google\_containers\/heapster-grafana-amd64:v4.4.3/g<br />
PS:<br />
  \_\_IMAGE\_\_heapster\_\_grafana\_\_  替换为  heapster-grafana-amd64的docker镜像<br />
  如果gcr.io连不上<br />
  heapster-grafana-amd64  可以使用  uufengfeng\/heapster-grafana-amd64:v4.0.2<br />
#
value: /<br />
value: /api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/<br />
如果后续使用 kube-apiserver 或者 kubectl proxy 访问 grafana dashboard,则必须将 GF\_SERVER\_ROOT\_URL 设置为 /api/v1/proxy/namespaces/kubesystem/services/monitoring-grafana/,否则后续访问grafana时访问时提示找不到 http://10.64.3.7:8086/api/v1/proxy/namespaces/kubesystem/services/monitoring-grafana/api/dashboards/home<br />
<br />
官方:<br />
 /api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/<br />
kube 1.7版要修改为<br />
 /api/v1/namespaces/kube-system/services/monitoring-grafana/proxy/<br />

#heapster.yaml<br />
vim编辑<br />
  %s/\_\_IMAGE\_\_heapster\_\_/gcr.io\/google\_containers\/heapster-amd64:v1.3.0/g<br />
PS:<br />
  \_\_IMAGE\_\_heapster\_\_  替换为  heapster-amd64的docker镜像<br />
  如果gcr.io连不上<br />
  heapster-amd64  可以使用  uufengfeng\/heapster-amd64:v1.3.0<br />
#
#influxdb.yaml<br />
vim编辑<br />
  %s/\_\_IMAGE\_\_heapster\_\_influxdb\_\_/gcr.io\/google\_containers\/heapster-influxdb-amd64:v1.1.1/g<br />
PS:<br />
  \_\_IMAGE\_\_heapster\_\_influxdb\_\_  替换为  heapster-influxdb-amd64的docker镜像<br />
  如果gcr.io连不上<br />
  heapster-influxdb-amd64  可以使用  uufengfeng\/heapster-influxdb-amd64:v1.1.1<br />
#
#heapster-rbac.yaml<br />
未修改<br />
<br />
创建<br />
kubectl create -f grafana.yaml<br />
kubectl create -f heapster.yaml<br />
kubectl create -f heapster-rbac.yaml<br />
kubectl create -f influxdb.yaml<br />
<br />
删除插件<br />
kubectl delete svc,deploy monitoring-grafana -n kube-system<br />
kubectl delete sa,deploy,svc heapster -n kube-system<br />
kubectl delete ClusterRoleBinding heapster <br />
kubectl delete deploy,svc monitoring-influxdb -n kube-system<br />

FAQ<br />
错误<br />
t=2017-11-01T07:42:56+0000 lvl=crit msg="Failed to parse /etc/grafana/grafana.ini, open /etc/grafana/grafana.ini: no such file or direct {}=[])"<br />
降低heapster-grafana-amd64版本,uufengfeng/heapster-grafana-amd64:latest版本为4.0.2<br />
