#!/usr/bin/env bash
## 简单的sqoop例子，将mysql中的movie表数据导入到HDFS中
## 指定字段进行分区，默认是4个分区，对应着4个MapTask
sqoop import --connect jdbc:mysql://master:3306/movie --username root --password root --table movie --split-by id -m 2


hadoop fs -rm -r /user/hadoop-twq/movie
## 参数-m的含义
sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --password root \
--table movie -m 1

## 参数--delete-target-dir的含义，表示删除已经存在的目录
sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --password root \
--table movie -m 1 --delete-target-dir

## 参数--target-dir的含义
sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --password root \
--table movie -m 1 \
--target-dir /user/hadoop-twq/movielens/movie --delete-target-dir

## 将HDFS中的movie数据导入到hive表中
hive -f /home/hadoop-twq/dw-course/0_1_sqoop_example.sql

## 直接将mysql中的数据导入到hive表中
## 1、需要在~/.bash_profile文件中增加配置：
##		export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HIVE_HOME/lib/*
## 		export HIVE_CONF_DIR=$HIVE_HOME/conf
## 2、在slav1和slave2上安装Hive，且配置HIVE_HOME、HADOOP_CLASSPATH以及HIVE_CONF_DIR环境变量
## 3、将$SQOOP_HOME/lib/jackson*.jar备份为文件bak，然后cp $HIVE_HOME/lib/jackson*.jar $SQOOP_HOME/lib
## 4、sudo vi $JAVA_HOME/jre/lib/security/java.policy 增加：
## 		permission javax.management.MBeanTrustPermission "register";
## 5、将java-json.jar包放到$SQOOP_HOME/lib下
sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --password root \
--table movie -m 1 --delete-target-dir \
--hive-import

sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --password root \
--table movie -m 1 --delete-target-dir \
--hive-import \
--hive-overwrite \
--hive-table movie_sqoop \
--hive-database movielens
