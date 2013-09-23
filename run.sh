#!/bin/bash

if [ ! -e "logstash-1.1.13-flatjar.jar" ]; then
    echo '[INFO] Download logstash-1.1.13'
    wget http://semicomplete.com/files/logstash/logstash-1.1.13-flatjar.jar
fi


nohup java -jar -Xms128m -Xmx128m -XX:MaxPermSize=64m \
    logstash-1.1.13-flatjar.jar agent \
    -f nvs-agent.conf &
