[![Build Status](https://travis-ci.org/alibaba/dubbo.svg?branch=master)](https://travis-ci.org/alibaba/dubbo) [![Gitter](https://badges.gitter.im/alibaba/dubbo.svg)](https://gitter.im/alibaba/dubbo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Dubbo is a distributed, high performance RPC framework which empowers applications with service import/export capabilities.

It contains three key parts, which include:

* **Remoting**: a network communication framework providing sync-over-async and request-response messaging.
* **Clustering**: a remote procedure call abstraction with load-balancing/failover/clustering capabilities.
* **Registration**: a service directory framework for service registration and service event publish/subscription

For more details, please refer to [wiki](https://github.com/alibaba/dubbo/wiki) or [dubbo.io](http://dubbo.io).

## Quick Start


Export service:

```xml
<bean id="barService" class="com.foo.BarServiceImpl" />
<dubbo:service interface="com.foo.BarService" ref="barService" />
```

Refer to service:

```xml
<dubbo:reference id="barService" interface="com.foo.BarService" />
	
<bean id="barAction" class="com.foo.BarAction">
    <property name="barService" ref="barService" />
</bean>
```

## Source Building


0. Install the git and maven command line:

```sh
yum install git
or: apt-get install git
cd ~
wget http://www.apache.org/dist//maven/binaries/apache-maven-2.2.1-bin.tar.gz
tar zxvf apache-maven-2.2.1-bin.tar.gz
vi .bash_profile
append: export PATH=$PATH:~/apache-maven-2.2.1/bin
source .bash_profile
```

0. Checkout the dubbo source code:

```sh
cd ~
git clone https://github.com/alibaba/dubbo.git dubbo
git checkout master
or: git checkout -b dubbo-2.*
```

0. Import the dubbo source code to eclipse project:

```sh
cd ~/dubbo
mvn eclipse:eclipse
```

    Then configure the project in eclipse by following the steps below:
    * Eclipse -> Menu -> File -> Import -> Exsiting Projects to Workspace -> Browse -> Finish
    * Context Menu -> Run As -> Java Application:
        * dubbo-demo-provider/src/test/java/com.alibaba.dubbo.demo.provider.DemoProvider
        * dubbo-demo-consumer/src/test/java/com.alibaba.dubbo.demo.consumer.DemoConsumer
        * dubbo-monitor-simple/src/test/java/com.alibaba.dubbo.monitor.simple.SimpleMonitor
        * dubbo-registry-simple/src/test/java/com.alibaba.dubbo.registry.simple.SimpleRegistry
    * Edit Config:
        * dubbo-demo-provider/src/test/resources/dubbo.properties
        * dubbo-demo-consumer/src/test/resources/dubbo.properties
        * dubbo-monitor-simple/src/test/resources/dubbo.properties
        * dubbo-registry-simple/src/test/resources/dubbo.properties

0. Build the dubbo binary package:

```sh
cd ~/dubbo
mvn clean install -Dmaven.test.skip
cd dubbo/target
ls
```

0. Install the demo provider:

```sh
cd ~/dubbo/dubbo-demo/dubbo-demo-provider/target
tar zxvf dubbo-demo-provider-2.*-assembly.tar.gz
cd dubbo-*-SNAPSHOT/bin
./start.sh
```

0. Install the demo consumer:

```sh
cd ~/dubbo/dubbo-demo/dubbo-demo-consumer/target
tar zxvf dubbo-demo-consumer-2.*-assembly.tar.gz
cd dubbo-*-SNAPSHOT/bin
./start.sh
cd ../logs
tail -f stdout.log
```

0. Install the simple monitor:

```sh
cd ~/dubbo/dubbo-simple/dubbo-monitor-simple/target
tar zxvf dubbo-monitor-simple-2.*-assembly.tar.gz
cd dubbo-*-SNAPSHOT/bin
./start.sh
http://127.0.0.1:8080
```

0. Install the simple registry:

```sh
cd ~/dubbo/dubbo-simple/dubbo-registry-simple/target
tar zxvf dubbo-registry-simple-2.*-assembly.tar.gz
cd dubbo-*-SNAPSHOT/bin
./start.sh

cd ~/dubbo/dubbo-demo/dubbo-demo-provider/target/dubbo-*-SNAPSHOT/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=dubbo/g' > dubbo.properties
cd ../bin
./restart.sh

cd ~/dubbo/dubbo-demo/dubbo-demo-consumer/target/dubbo-*-SNAPSHOT/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=dubbo/g' > dubbo.properties
cd ../bin
./restart.sh

cd ~/dubbo/dubbo-simple/dubbo-monitor-simple/target/dubbo-*-SNAPSHOT/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=dubbo/g' > dubbo.properties
cd ../bin
./restart.sh
```

0. Install the zookeeper registry:

```sh
cd ~
wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz
tar zxvf zookeeper-*.tar.gz
cd zookeeper-*/conf
cp zoo_sample.cfg zoo.cfg
#vi zoo.cfg
#- edit: dataDir=/home/xxx/data
cd ../bin
./zkServer.sh start

cd ~/dubbo/dubbo-demo/dubbo-demo-provider/target/dubbo-*-SNAPSHOT/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=zookeeper/g' > dubbo.properties
cd ../bin
./restart.sh

cd ~/dubbo/dubbo-demo/dubbo-demo-consumer/target/dubbo-*-SNAPSHOT/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=zookeeper/g' > dubbo.properties
cd ../bin
./restart.sh

cd ~/dubbo/dubbo-simple/dubbo-monitor-simple/target/dubbo-*-SNAPSHOT/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=zookeeper/g' > dubbo.properties
cd ../bin
./restart.sh
```

0. Install the redis registry:

```sh
cd ~
wget http://redis.googlecode.com/files/redis-2.4.8.tar.gz
tar xzf redis-2.4.8.tar.gz
cd redis-2.4.8
make
nohup ./src/redis-server redis.conf &
cd ~/dubbo/dubbo-demo-provider/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=redis/g' > dubbo.properties
cd ../bin
./restart.sh
cd ~/dubbo/dubbo-demo-consumer/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=redis/g' > dubbo.properties
cd ../bin
./restart.sh
cd ~/dubbo/dubbo-simple-monitor/conf
mv dubbo.properties dubbo.properties.bak
cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=redis/g' > dubbo.properties
cd ../bin
./restart.sh
```

0. Install the admin console:

```sh
cd ~/dubbo/dubbo-admin
mvn jetty:run -Ddubbo.registry.address=zookeeper://127.0.0.1:2181
```
visit [dubbo-admin](http://root:root@dubbo:8081/governance/services)

