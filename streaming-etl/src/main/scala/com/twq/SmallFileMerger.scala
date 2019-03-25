package com.twq

import org.apache.spark.sql.{SaveMode, SparkSession}

/**
  * 使用Spark SQL合并小文件
  */
object SmallFileMerger {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder()
      .appName("SmallFileMerger")
      .master("local")
      .getOrCreate()

    val inputPath = spark.conf.get("spark.small.file.merge.inputPath",
      "hdfs://master:9999/user/hadoop-twq/dw-course/streaming-etl/user-action-parquet/year=2018/month=201806/day=20180613")

    val numberPartition = spark.conf.get("spark.small.file.merge.numberPartition", "2").toInt

    val outputPath = spark.conf.get("spark.small.file.merge.outputPath",
      "hdfs://master:9999/user/hadoop-twq/dw-course/streaming-etl/user-action-merged/year=2018/month=201806/day=20180613")

    spark.read.parquet(inputPath)
      .repartition(numberPartition)
      //.coalesce(numberPartition)
      .write
      .mode(SaveMode.Overwrite)
      .parquet(outputPath)

    spark.stop()
  }
}
