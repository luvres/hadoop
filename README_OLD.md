## Hadoop 2.8.5 Ecosystem
## Big Data Engineering and Analytics
-----
### Linux OS options: Debian Jessie, CentOS 7, Centos 6.8
### and Alpine Linux (483 MB)
#### · Pseudo distributed mode
#### · Fully distributed mode
### PySpark Jupyter Notebook - Kernels (Python, R, Julia)
### RStudio Server
### ETL - (Data Lake)
#### . Raise and Import databases Mariadb and Oracle 11g with sqoop
#### . Hive, Pig, HBase
#### . JDBC implemented and ready for sqoop and spark
### Machine Learning
#### . Mahout (Naive Bayes, K-Means)
-----
## Fully distributed mode
### One host containers
#### Script for your cluster from 1 to 9 nodes.
```
curl -L https://raw.githubusercontent.com/luvres/hadoop/master/zoneCluster.sh -o ~/zoneCluster.sh
alias zoneCluster="bash ~/zoneCluster.sh"
```
#### Create a directory for notebooks and Include directory created above on flag "-v"
```
mkdir $HOME/notebooks
```
#### Create cluster of a node 
#### The total of 2, as the namenode assumes one more node
```
zoneCluster
```
#### Hadoop Browser
```
http://localhost:8088

http://localhost:50070
```
#### HBase Browser
```
http://localhost:60010
```
#### Access by Jupyter Notebook
```
http://localhost:8888/terminals/1

 sh-4.2# bash <enter>
```
#### To create a cluster of maximum 9 nodes (10 including the namenode)
```
zoneCluster 3

docker logs -f Hadoop
```
##### Note: The script is limited to a maximum of 9 nodes because multiple hosts are being created on only one host and I see no point in overloading your machine. The settings are ready for a real cluster and in the future I want to create scripts for provisioning with docker swarm.

##### Options: { stop | start | remove | Stop | pseudo | cos6 | cos7 | alpine }

#### Stop and Remove the cluster
```
zoneCluster Stop
```

-----
## ETL - (Data Lake)
### Import databases Mariadb and Oracle 11g with sqoop
```
zoneCluster 2 -db
```
### Import data from Mariadb with Sqoop
```
http://localhost:8888/terminals/1
# bash <Enter>

sqoop import \
	--connect jdbc:mysql://mariadb:3306/mysql \
	--username root \
	--password maria \
	--table user -m 1
```
#### Checking imported data for the hdfs
```
hdfs dfs -ls -R user
```
### Import data from Oracle with Sqoop
#### Access Oracle
```
docker exec -ti OracleXE bash
cd $HOME/data/
```
#### Download file
```
curl -O http://files.grouplens.org/datasets/movielens/ml-20m.zip
unzip ml-20m.zip
cd ml-20m
```
#### Create file 100 times smaller
```
cat ratings.csv |tail -n $((`cat ratings.csv | wc -l` /100)) >ml_ratings.csv
```
#### Load table in Oracle
#### Access database and create user
```
sqlplus sys/oracle as sysdba
```
#### Create the schema in the database and grant privileges
```
SQL> create user aluno identified by dsacademy;
SQL> grant connect, resource, unlimited tablespace to aluno;
SQL> conn aluno@xe/dsacademy
SQL> select user from dual;
```
#### Create a table in the Oracle database
```
SQL> CREATE TABLE cinema ( 
  ID   NUMBER PRIMARY KEY, 
  USER_ID       VARCHAR2(30), 
  MOVIE_ID      VARCHAR2(30),
  RATING        DECIMAL(30),
  TIMESTAMP     VARCHAR2(256) 
);

SQL> desc cinema;

SQL> quit
```
#### Create file loader.dat
```
tee $HOME/data/loader.dat <<EOF
load data
INFILE '$HOME/data/ml-20m/ml_ratings.csv'
INTO TABLE cinema
APPEND
FIELDS TERMINATED BY ','
trailing nullcols
(id SEQUENCE (MAX,1),
 user_id CHAR(30),
 movie_id CHAR(30),
 rating   decimal external,
 timestamp  char(256))
EOF
```
#### Run SQL * Loader
```
sqlldr userid=aluno/dsacademy control=$HOME/data/loader.dat log=$HOME/data/loader.log
```
#### Check load
```
sqlplus aluno/dsacademy

SQL> select count(*) from cinema;
```
#### Import with Sqoop
```
http://localhost:8888/terminals/1
# bash <Enter>

sqoop import \
--connect jdbc:oracle:thin:@oraclexe:1521:XE \
--username aluno \
--password dsacademy \
--query "select user_id, movie_id from cinema where rating = 1 and \$CONDITIONS" \
--target-dir /user/oracle/output -m 1
```

-----
### Hive (Structured Data in hdfs)
#### Download and copy dataset to hdfs
```
curl -O  https://raw.githubusercontent.com/luvres/hadoop/master/datasets/empregados.csv

hdfs dfs -mkdir /hive
hdfs dfs -copyFromLocal empregados.csv /hive
```
#### Create the first schema on Hive (Before starting Hive)
```
schematool -initSchema -dbType derby
```
#### If you have problems with the previous command
```
rm metastore_db -fR
```
#### Start Hive
```
hive
```
#### Create table to receive the file
```
CREATE TABLE temp_colab (texto String);
```
#### Upload file data
```
LOAD DATA INPATH '/hive/empregados.csv' OVERWRITE INTO TABLE temp_colab;
```
#### Check file insertion
```
SELECT * FROM temp_colab;
```
#### Extract data from table temp_colab and separate by column
```
CREATE TABLE IF NOT EXISTS colaboradores(
id int,
nome String,
cargo String,
salario double,
cidade String
);

insert overwrite table colaboradores
SELECT
regexp_extract(texto, '^(?:([^,]*),?){1}', 1) ID,
regexp_extract(texto, '^(?:([^,]*),?){2}', 1) nome,
regexp_extract(texto, '^(?:([^,]*),?){3}', 1) cargo,
regexp_extract(texto, '^(?:([^,]*),?){4}', 1) salario,
regexp_extract(texto, '^(?:([^,]*),?){5}', 1) cidade
from temp_colab;
```
#### HiveQL Commands
```
SELECT * FROM colaboradores;

SELECT * FROM colaboradores WHERE Id = 3002;

SELECT sum(salario), cidade from colaboradores group by cidade;
```
-----
## Machine Learning
### Creation of the Predictive Model with Naive Bayes
#### Create Folders in HDFS
```
hdfs dfs -mkdir -p /mahout/input/{ham,spam}
```
#### Download and copy dataset to hdfs
```
curl https://raw.githubusercontent.com/luvres/hadoop/master/datasets/ham.tar.gz | tar -xzf -
curl https://raw.githubusercontent.com/luvres/hadoop/master/datasets/spam.tar.gz | tar -xzf -

hdfs dfs -copyFromLocal ham/* /mahout/input/ham

hdfs dfs -copyFromLocal spam/* /mahout/input/spam
```
#### Converts data to a sequence (required when working with Mahout)
```
mahout seqdirectory -i /mahout/input -o /mahout/output/seqoutput
```
#### Converts the sequence to TF-IDF vectors
```
mahout seq2sparse -i /mahout/output/seqoutput -o /mahout/output/sparseoutput
```
#### Displays output
```
hdfs dfs -ls /mahout/output/sparseoutput
```
#### Convert training and test datasets
```
mahout split -i /mahout/output/sparseoutput/tfidf-vectors --trainingOutput /mahout/nbTrain --testOutput /mahout/nbTest --randomSelectionPct 30 --overwrite --sequenceFiles -xm sequencial
```
#### Predictive model construction
```
mahout trainnb -i /mahout/nbTrain -li /mahout/nbLabels -o /mahout/nbmodel -ow -c
```
#### Test model
```
mahout testnb -i /mahout/nbTest -m /mahout/nbmodel -l /mahout/nbLabels -ow -o /mahout/nbpredictions -c
```
### Creating a Predictive Model of Unsupervised Learning with K-Means
#### Create Folders in HDFS
```
hdfs dfs -mkdir -p /mahout/clustering/data
```
#### Download and copy dataset to hdfs
```
curl https://raw.githubusercontent.com/luvres/hadoop/master/datasets/news.tar.gz | tar -xzf -

hdfs dfs -copyFromLocal news/* /mahout/clustering/data
```
#### Converts the dataset to sequence object
```
mahout seqdirectory -i /mahout/clustering/data -o /mahout/clustering/kmeansseq
```
#### Converts the sequence to TF-IDF vectors
```
mahout seq2sparse -i /mahout/clustering/kmeansseq -o /mahout/clustering/kmeanssparse

hdfs dfs -ls /mahout/clustering/kmeanssparse
```
#### Building the K-means model
```
mahout kmeans -i /mahout/clustering/kmeanssparse/tfidf-vectors/ -c /mahout/clustering/kmeanscentroids  -cl -o /mahout/clustering/kmeansclusters -k 3 -ow -x 10 -dm org.apache.mahout.common.distance.CosineDistanceMeasure

hdfs dfs -ls /mahout/clustering/kmeansclusters
```
#### Dump clusters to a text file
```
mahout clusterdump -d /mahout/clustering/kmeanssparse/dictionary.file-0 -dt sequencefile -i /mahout/clustering/kmeansclusters/clusters-1-final -n 20 -b 100 -o clusterdump.txt -p /mahout/clustering/kmeansclusters/clusteredPoints/
```
#### View clusters
```
cat clisterdump.txt
```
-----
### PySpark with Jupyter Notebook
#### Browser access
```
http://localhost:8888
```
#### Spark management jobs
```
http://localhost:4040
```
### RStudio Server
#### Browser access
```
http://localhost:8787

username: root
password: root
```
### Creates a pseudo-distributed instance
```
zoneCluster pseudo
```
#### Equivalent to the command
```
docker run --rm --name Hadoop -h hadoop \
-p 8088:8088 -p 8042:8042 -p 50070:50070 -p 8888:8888 -p 4040:4040 \
-v $HOME/notebooks:/root/notebooks \
-ti izone/hadoop:ecosystem bash
```
### Julia (Linear regression)
```
http://localhost:8888/terminals/1
bash

curl -O https://raw.githubusercontent.com/luvres/hadoop/master/julia/dataset/multilinreg.jl
curl -O https://raw.githubusercontent.com/luvres/hadoop/master/julia/dataset/data.txt

julia multilinreg.jl
```
-----
### Pull image latest (with Debian 8)
```
docker pull izone/hadoop
```
#### Run pulled image (Optional flag "-test" to start with a PI test)
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-ti izone/hadoop -test bash
```
#### Pull image with CentOS 7
```
docker pull izone/hadoop:cos7
```
#### Pull image with CentOS 6
```
docker pull izone/hadoop:cos6
```
### Pull reduced image with Alpine (483 MB)
```
docker pull izone/hadoop:alpine
```
#### Run pulled image (Optional flag "-test" to start with a PI test)
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-ti izone/hadoop:alpine -test bash
```
-----
## Examples:

### Hadoop Map Reduce

##### Create a Directory
```
hdfs dfs -mkdir /bigdata
```
##### List diretory
```
hadoop fs -ls /
```
##### Download a file csv
```
wget -c http://compras.dados.gov.br/contratos/v1/contratos.csv
```
##### Copy file to the HDFS directory created above
```
hadoop fs -copyFromLocal contratos.csv /bigdata
```
##### Read file
```
hadoop fs -cat /bigdata/contratos.csv
```
##### Test word count with mapreduce
```
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.5.jar wordcount /bigdata/contratos.csv /output
```
##### Read result
```
hdfs dfs -cat /output/*
```

### Spark MapReduce

#### pyspark jupyter notebook
```
http://localhost:8888/
new -> python
```
##### Terminal commands executed with "!" Straight into the notebook
##### It is the same as running direct on the terminal
```
!mkdir datasets
!curl -L http://www.gutenberg.org/files/11/11-0.txt -o datasets/book.txt
!hdfs dfs -mkdir -p /spark/input
!hdfs dfs -put datasets/book.txt /spark/input
!hdfs dfs -ls /spark/input
```
##### Examples of http://spark.apache.org/examples.html
```
text_file = sc.textFile("hdfs://localhost:9000/spark/input/book.txt")

counts = text_file.flatMap(lambda line: line.split(" ")) \
             .map(lambda word: (word, 1)) \
             .reduceByKey(lambda a, b: a + b)

counts.saveAsTextFile("hdfs://localhost:9000/spark/output"
```
##### View result
```
!hdfs dfs -ls /spark/output
!hdfs dfs -cat /spark/output/part-00000
```

### Spark Yarn management

##### Client enviroment
```
export HADOOP_CONF_DIR=/etc/hadoop/conf
export YARN_CONF_DIR=/etc/hadoop/conf
```
#### Submit
```
spark-submit --class org.apache.spark.examples.SparkPi --master yarn-cluster $SPARK_HOME/examples/jars/spark-examples_2.11-2.0.2.jar 10
```
-----
### Pull image with Anaconda
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-p 8888:8888 \
	-p 4040:4040 \
	-v $HOME/notebooks:/root/notebooks \
	-ti izone/hadoop:anaconda bash
```
### Pull image with RStudio
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-p 8888:8888 \
	-p 4040:4040 \
	-p 8787:8787 \
	-v $HOME/notebooks:/root/notebooks \
	-ti izone/hadoop:rstudio bash
```
-----
### AUTO CONSTRUCTION creation sequence that are in the Docker Hub

### Debian 8 (Jessie)
```
git clone https://github.com/luvres/hadoop.git
cd hadoop

docker build -t izone/hadoop . && \
docker build -t izone/hadoop:anaconda ./anaconda/ && \
docker build -t izone/hadoop:rstudio ./rstudio/ && \
docker build -t izone/hadoop:julia ./julia/ && \
docker build -t izone/hadoop:ecosystem ./ecosystem/ && \
docker build -t izone/hadoop:cluster ./cluster/ && \
docker build -t izone/hadoop:datanode ./cluster/datanode/
```
### CentOS 7
```
git clone https://github.com/luvres/hadoop.git
cd hadoop

docker build -t izone/hadoop:cos7 ./centos7/ && \
docker build -t izone/hadoop:cos7-miniconda ./centos7/miniconda/ && \
docker build -t izone/hadoop:cos7-ecosystem ./centos7/ecosystem/ && \
docker build -t izone/hadoop:cos7-anaconda ./centos7/anaconda/ && \
docker build -t izone/hadoop:cos7-mahout ./centos7/mahout/ && \
docker build -t izone/hadoop:cos7-cluster ./centos7/cluster/ && \
docker build -t izone/hadoop:cos7-datanode ./centos7/cluster/datanode/

```
### CentOS 6
```
git clone https://github.com/luvres/hadoop.git
cd hadoop

docker build -t izone/hadoop:cos6 ./centos6/ && \
docker build -t izone/hadoop:cos6-miniconda ./centos6/miniconda/ && \
docker build -t izone/hadoop:cos6-ecosystem ./centos6/ecosystem/ && \
docker build -t izone/hadoop:cos6-anaconda ./centos6/anaconda/ && \
docker build -t izone/hadoop:cos6-rstudio ./centos6/rstudio/ && \
docker build -t izone/hadoop:cos6-mahout ./centos6/mahout/ && \
docker build -t izone/hadoop:cos6-cluster ./centos6/cluster/ && \
docker build -t izone/hadoop:cos6-datanode ./centos6/cluster/datanode/
```
### Alpine
```
git clone https://github.com/luvres/hadoop.git
cd hadoop

docker build -t izone/hadoop:alpine ./alpine/ && \
docker build -t izone/hadoop:alpine-datanode ./alpine/datanode/
```
