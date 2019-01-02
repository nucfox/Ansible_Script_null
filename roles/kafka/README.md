[kafka broker配置](https://kafka.apache.org/documentation/#brokerconfigs)  
---
参数 | 说明
---|---
advertised.listeners| 广播监听器地址,如果未设置则使用listeners作为默认值,通知客服端使用此地址连接
broker.id | 服务器代理ID,集群中唯一,如果未设置,zookeeper会生成代理ID,为了避免zookeeper生成的代理ID和用户配置的代理ID之间发生冲突,生成的代理ID从reserved.broker.max.id + 1开始
listeners|监听地址
zookeeper.connect|zookeeper连接地址,地址:端口,也可使用host1:port,host2:port,host3:port连接zookeeper集群,也可改变命名空间,将数据放在zookeeper某个路径下,如host1:port,host2:port,host3:port/chroot/path
log.dirs|保存日志数据的目录.如果未设置,则使用log.dir中的值
---
##### 开启jmx监控  
&emsp;docker环境变量设置,hostname要设置成宿主机的地址  
```
version: '2'
services:
  kafka:
  ......
  environment:
    ......
    KAFKA_JMX_OPTS: "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.1.6 -Dcom.sun.management.jmxremote.rmi.port=1099"
    JMX_PORT: 1099
```
&emsp;docker安装时,broker_id需要设置inventory变量,以区分id  
###### ini格式
```
[kafka]
192.168.1.1 broker_id=1
192.168.1.2 broker_id=2
192.168.1.3 broker_id=3
```
###### yml格式

```
all:
  children:
    kafka:
      hosts:
        192.168.1.1:
          broker_id: 1
        192.168.1.2:
          broker_id: 2
        192.168.1.3:
          broker_id: 3
```
