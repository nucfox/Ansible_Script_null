[官方链接](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod)</br>
k8s使用私有库需要把~/.docker/config.json信息输出并以base64编码</br>
```sh
# cat ~/.docker/config.json
{
	"auths": {
		"10.100.57.58": {
			"auth": "YWRtaW46SGFyYm9yMTIzNDU="
		}
	}
# cat ~/.docker/config.json | base64
ewoJImF1dGhzIjogewoJCSIxMC4xMDAuNTcuNTgiOiB7CgkJCSJhdXRoIjogIllXUnRhVzQ2U0dGeVltOXlNVEl6TkRVPSIKCQl9Cgl9Cn0=
```
并在k8s创建Secret</br>
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: myregistrykey
data:
  .dockerconfigjson: ewoJImF1dGhzIjogewoJCSIxMC4xMDAuNTcuNTgiOiB7CgkJCSJhdXRoIjogIllXUnRhVzQ2U0dGeVltOXlNVEl6TkRVPSIKCQl9Cgl9Cn0=
type: kubernetes.io/dockerconfigjson
```
pod示例:</br>
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-harbor-nginx6
spec:
  containers:
  - name: nginx
    image: 10.100.57.58/test/nginx:1.11.6
    ports:
    - containerPort: 80
  imagePullSecrets:
    - name: myregistrykey
```
