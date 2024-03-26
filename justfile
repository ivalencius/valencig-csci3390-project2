default:
    just --list

build:
    sbt clean package

set export
csv_path := "2014to2017.csv"

exactF0:
    spark-submit --class project_2.main --master local[*] target/scala-2.12/project_2_2.12-1.0.jar $csv_path exactF0

exactF2:
    spark-submit --class project_2.main --master local[*] target/scala-2.12/project_2_2.12-1.0.jar $csv_path exactF2

tow:
    spark-submit --class project_2.main --master local[*] target/scala-2.12/project_2_2.12-1.0.jar $csv_path ToW 10 3

bjkst:
    spark-submit --class project_2.main --master local[*] target/scala-2.12/project_2_2.12-1.0.jar $csv_path BJKST 14400 5
