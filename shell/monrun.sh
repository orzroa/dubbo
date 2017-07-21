#!/bin/bash

cd ~/dubbo/dubbo-simple/dubbo-monitor-simple/target

if [ `ls *T|wc -l` -eq 0 ]; then
  tar zxvf dubbo-monitor-simple-2.*-assembly.tar.gz
fi

cd dubbo-*-SNAPSHOT

cd conf
if [ ! -x dubbo.properties.bak ]; then
  mv dubbo.properties dubbo.properties.bak
  cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=zookeeper/g' > dubbo.properties
fi

cd ..
bin/$1.sh

