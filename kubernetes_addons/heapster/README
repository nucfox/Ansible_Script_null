#
官方heapster插件地址
https://github.com/kubernetes/heapster/releases/latest

解压
官方文件目录： heapster-1.4.3/deploy/kube-config/influxdb
heapster-rbac.yaml文档 heapster-1.4.3/deploy/kube-config/rbac


grafana.yaml
vim编辑
  %s/__IMAGE__heapster__grafana__/gcr.io\/google_containers\/heapster-grafana-amd64:v4.4.3/g
PS:
  __IMAGE__heapster__grafana__  替换为  heapster-grafana-amd64的docker镜像
  如果gcr.io连不上
  heapster-grafana-amd64  可以使用  uufengfeng\/heapster-grafana-amd64:latest

# value: /
value: /api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/
如果后续使用 kube-apiserver 或者 kubectl proxy 访问 grafana dashboard,则必须将 GF_SERVER_ROOT_URL 设置为 /api/v1/proxy/namespaces/kubesystem/services/monitoring-grafana/,否则后续访问grafana时访问时提示找不到 http://10.64.3.7:8086/api/v1/proxy/namespaces/kubesystem/services/monitoring-grafana/api/dashboards/home

官方:
 /api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/
kube 1.7版要修改为
 /api/v1/namespaces/kube-system/services/monitoring-grafana/proxy/



heapster.yaml
vim编辑
  %s/__IMAGE__heapster__/gcr.io\/google_containers\/heapster-amd64:v1.3.0/g
PS:
  __IMAGE__heapster__  替换为  heapster-amd64的docker镜像                  
  如果gcr.io连不上
  heapster-amd64  可以使用  uufengfeng\/heapster-amd64:latest

influxdb.yaml
vim编辑
  %s/__IMAGE__heapster__influxdb__/gcr.io\/google_containers\/heapster-influxdb-amd64:v1.1.1/g
PS:
  __IMAGE__heapster__influxdb__  替换为  heapster-influxdb-amd64的docker镜像                                   
  如果gcr.io连不上
  heapster-influxdb-amd64  可以使用  uufengfeng\/heapster-influxdb-amd64:latest

heapster-rbac.yaml
未修改

创建
kubectl create -f grafana.yaml
kubectl create -f heapster.yaml
kubectl create -f heapster-rbac.yaml
kubectl create -f influxdb.yaml

删除插件
kubectl delete svc,deploy monitoring-grafana -n kube-system
kubectl delete sa,deploy,svc heapster -n kube-system
kubectl delete deploy,svc monitoring-influxdb -n kube-system

FAQ
错误
t=2017-11-01T07:42:56+0000 lvl=crit msg="Failed to parse /etc/grafana/grafana.ini, open /etc/grafana/grafana.ini: no such file or direct {}=[])"
降低heapster-grafana-amd64版本,uufengfeng/heapster-grafana-amd64:latest版本为4.0.2
