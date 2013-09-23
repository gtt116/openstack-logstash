#!/bin/bash
action=$1

case "$action" in
    start)
        if [ ! -e "logstash-1.1.13-flatjar.jar" ]; then
            echo '[INFO] Download logstash-1.1.13'
            wget http://semicomplete.com/files/logstash/logstash-1.1.13-flatjar.jar
        fi

        if [ -e PID ]; then
            pid=`cat PID`
            echo "[ERROR] logstash PID: $pid is running"
            exit 1
        fi

        nohup java -jar -Xms128m -Xmx128m -XX:MaxPermSize=64m \
            logstash-1.1.13-flatjar.jar agent \
            -f nvs-agent.conf &
        echo $! > PID
        ;;
    stop)
        pid=`cat PID`
        echo "Stopping $pid"
        kill `cat PID`
        rm PID
        ;;
    *)
        echo "Usage: $0 <start|stop>"
        exit 1
        ;;
esac
