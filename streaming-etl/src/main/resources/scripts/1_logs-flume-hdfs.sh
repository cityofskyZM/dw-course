#!/usr/bin/env bash
## 启动log-webServer的命令：
## 1、日志一直放在同一个文件中
java -DLOG_HOME="/home/hadoop-twq/dw-course/streaming-etl/logs"  \
-jar log-web-1.0-SNAPSHOT.jar \
--server.port=8090 \
--logging.config=/home/hadoop-twq/dw-course/streaming-etl/logback/allfile_logback.xml

## 使用exec的方式收集日志：
apache-flume-1.8.0-bin/bin/flume-ng agent --conf conf --conf-file flume/exec-hdfs_flume-conf.properties --name agent1

## 2、日志每分钟一个文件
java -DLOG_HOME="/home/hadoop-twq/dw-course/streaming-etl/logs/minute"  \
-jar log-web-1.0-SNAPSHOT.jar \
--server.port=8090 \
--logging.config=/home/hadoop-twq/dw-course/streaming-etl/logback/minute_logback.xml

## 使用spooling dir的方式收集日志：
apache-flume-1.8.0-bin/bin/flume-ng agent --conf conf --conf-file flume/spooldir_flume-conf.properties --name agent1

## 3、日志每天一个文件，启动两个log-webServer
java -DLOG_HOME="/home/hadoop-twq/dw-course/streaming-etl/logs/daily"  \
-jar log-web-1.0-SNAPSHOT.jar \
--server.port=8090 \
--logging.config=/home/hadoop-twq/dw-course/streaming-etl/logback/daily_logback.xml &

java -DLOG_HOME="/home/hadoop-twq/dw-course/streaming-etl/logs/daily2"  \
-jar log-web-1.0-SNAPSHOT.jar \
--server.port=8091 \
--logging.config=/home/hadoop-twq/dw-course/streaming-etl/logback/daily_logback.xml &

## 使用TAILDIR的方式收集日志：
apache-flume-1.8.0-bin/bin/flume-ng agent --conf conf --conf-file flume/taildir_flume-conf.properties --name agent1

## 在Hive中创建一张表：
hive -e "CREATE EXTERNAL TABLE IF NOT EXISTS user_action (
    click_time STRING,
    client_ip STRING,
    user_id STRING,
    browser_name STRING,
    browser_code STRING,
    browser_useragent STRING,
    language STRING,
    screen_width STRING,
    screen_height STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t"
LOCATION 'hdfs://master:9999/user/hadoop-twq/dw-course/user-action-daily';"

## 4、演示什么是header
apache-flume-1.8.0-bin/bin/flume-ng agent --conf conf --conf-file flume/header_flume-conf.properties --name agent1 -Dflume.root.logger=INFO,console

## header的使用：
apache-flume-1.8.0-bin/bin/flume-ng agent --conf conf --conf-file flume/taildir_flume-conf.properties --name agent1

## 5、演示什么是Interceptor
apache-flume-1.8.0-bin/bin/flume-ng agent --conf conf --conf-file flume/interceptor_flume-conf.properties --name agent1 -Dflume.root.logger=INFO,console