#!/usr/bin/env bash
## 启动zookeeper
## 启动kafka
cd ~/bigdata/kafka_2.11-1.0.0
nohup bin/kafka-server-start.sh config/server.properties >~/bigdata/kafka_2.11-1.0.0/logs/server.log 2>&1 &

## 创建topic user-action
bin/kafka-topics.sh --create --zookeeper master:2181 --replication-factor 1 --partitions 2 --topic user-action

## 启动一个kafka consumer
bin/kafka-console-consumer.sh --bootstrap-server master:9092 --topic user-action --from-beginning


## 启动log-webServer
java -DLOG_HOME="/home/hadoop-twq/dw-course/streaming-etl/logs/daily"  \
-jar log-web-1.0-SNAPSHOT.jar \
--server.port=8090 \
--logging.config=/home/hadoop-twq/dw-course/streaming-etl/logback/daily_logback.xml &

##

