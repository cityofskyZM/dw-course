
--创建一张临时表
DROP TABLE IF EXISTS user_stage;
CREATE EXTERNAL TABLE user_stage (
    id INT,
    gender STRING,
    zip_code STRING,
    age INT,
    occupation STRING,
    last_modified STRING
)
ROW FORMAT DELIMITED
       FIELDS TERMINATED BY '\t'
LOCATION '/user/hadoop-twq/movielens/user_stage';

--创建user_rating_history表
CREATE EXTERNAL TABLE IF NOT EXISTS user_history (
    id INT,
    gender STRING,
    zip_code STRING,
    age INT,
    occupation STRING,
    last_modified STRING
)
PARTITIONED BY (year INT, month INT, day INT)
STORED AS AVRO;

SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT INTO TABLE user_history PARTITION(year, month, day)
SELECT *, year(last_modified) as year, month(last_modified) as month, day(last_modified) as day FROM user_stage;

CREATE EXTERNAL TABLE IF NOT EXISTS users (
    id INT,
    gender STRING,
    zip_code STRING,
    age INT,
    occupation STRING,
    last_modified STRING
)
STORED AS PARQUET;


--合并修改更新后的user
INSERT OVERWRITE TABLE users 
SELECT users.id, users.gender, users.zip_code, users.age, users.occupation, users.last_modified 
  FROM users LEFT JOIN user_stage ON users.id = user_stage.id WHERE user_stage.id IS NULL;
INSERT INTO TABLE users SELECT id, gender, zip_code, age, occupation, last_modified FROM user_stage;

  


