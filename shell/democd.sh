#!/bin/bash

cd ~/dubbo/dubbo-demo/dubbo-demo-$1/target

if [ `ls *T|wc -l` -eq 0 ]; then
  tar zxvf dubbo-demo-$1-2.*-assembly.tar.gz
fi

cd dubbo-*-SNAPSHOT

