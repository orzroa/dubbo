#!/bin/bash

cd ~/dubbo/dubbo-admin
mvn jetty:run -Ddubbo.registry.address=zookeeper://127.0.0.1:2181

