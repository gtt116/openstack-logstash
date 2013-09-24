#!/bin/bash
action=$1

function do_start(){
    if [ ! -e "logstash-1.1.13-flatjar.jar" ]; then
        echo '[INFO] Download logstash-1.1.13'
        wget http://semicomplete.com/files/logstash/logstash-1.1.13-flatjar.jar
    fi

    if [ -e PID ]; then
        pid=`cat PID`
        echo "[ERROR] logstash PID: $pid is running"
        return 1
    fi

    nohup java -jar -Xms128m -Xmx128m -XX:MaxPermSize=64m \
        logstash-1.1.13-flatjar.jar agent \
        -f nvs-agent.conf >/dev/null 2>/dev/null &
    echo $! > PID

    pid=`cat PID`
    echo "Running. pid: $pid"
}

function do_stop(){
    if [ ! -e PID ]; then
        echo 'Not running'
        return 1
    fi
    pid=`cat PID`
    echo "Stopping $pid"
    kill `cat PID`
    rm PID
}
case "$action" in
    start)
        do_start
        ;;
    stop)
        do_stop
        ;;
    restart)
        do_stop
        do_start
        ;;
    *)
        echo "Usage: $0 <start|stop|restart>"
        exit 1
        ;;
esac
