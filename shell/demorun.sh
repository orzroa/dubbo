#!/bin/bash

. democd.sh $1

cd conf
if [ ! -x dubbo.properties.bak ]; then
  mv dubbo.properties dubbo.properties.bak
  cat dubbo.properties.bak|sed 's/^dubbo.registry/#dubbo.registry/g'|sed 's/^#dubbo.registry.address=zookeeper/dubbo.registry.address=zookeeper/g' > dubbo.properties
fi

cd ..
bin/$2.sh

