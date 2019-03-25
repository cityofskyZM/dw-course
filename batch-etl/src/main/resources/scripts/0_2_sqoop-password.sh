#!/usr/bin/env bash
## --password 明文放在命令中，不安全，别人可以用history拿到密码
sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --password root \
--table movie -m 1 --delete-target-dir

## -P 执行的时候在控制台上输入密码，更加安全点
sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --P \
--table movie -m 1 --delete-target-dir

## --password-file 的方式更加的方便且安全
## 支持本地文件以及HDFS文件
## touch /home/hadoop-twq/.password
## echo -n "root"  >> /home/hadoop-twq/.password
## chmod 400 /home/hadoop-twq/.password
sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --password-file file:///home/hadoop-twq/.password \
--table movie -m 1 --delete-target-dir


## hadoop fs -put ~/.password /user/hadoop-twq
## hadoop fs -chmod 400 /user/hadoop-twq/.password
sqoop import --connect jdbc:mysql://master:3306/movie \
--username root --password-file /user/hadoop-twq/.password \
--table movie -m 1 --delete-target-dir
