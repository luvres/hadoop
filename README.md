## Hadoop 2.7.3
### With CentOS 7 (Centos option 6.8 also)
### Reduced Image Option with Alpine Linux (576.1 MB)
#### · Pseudo distributed mode
#### · Fully distributed mode
#### · PySpark with Jupyter Notebook
#### . Ecosystem:
##### . Hadoop, Spark, Zookeeper, HBase, Hive, Pig, Sqoop, Flume, Mahout
##### . JDBC implemented and ready for sqoop and spark
##### . Instances of MariaDB and Oracle 11g
---
### Script for your cluster from 1 to 9 nodes.
```
wget https://raw.githubusercontent.com/luvres/hadoop/master/zoneCluster.sh
alias zoneCluster="bash zoneCluster.sh"
mkdir $HOME/notebooks
```
### Create cluster of a node 
#### The total of 2, as the namenode assumes one more node
```
zoneCluster
```
### Hadoop Browser
```
http://localhost:8088

http://localhost:50070
```
#### Access by Jupyter Notebook
```
http://localhost:8888/terminals/1

 sh-4.2# bash <enter>
```
### To create a cluster of maximum 9 nodes (10 including the namenode)
```
zoneCluster 3

docker logs -f Hadoop
```
#### Note: The script is limited to a maximum of 9 nodes because multiple hosts are being created on only one host and I see no point in overloading your machine. The settings are ready for a real cluster and in the future I want to create scripts for provisioning with docker swarm.
### Stop the cluster
```
zoneCluster stop
```
### Raise Cluster with Mariadb and Oracle 11g Database
```
zoneCluster 2 -db
```
#### Import data from Mariadb with Sqoop
```
sqoop import \
	--connect jdbc:mysql://mariadb:3306/mysql \
	--username root \
	--password maria \
	--table user --m 1
```
#### Checking imported data for the hdfs
```
hdfs dfs -ls -R user
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
  -ti izone/hadoop:cos7-mahout bash
```
### AUTO CONSTRUCTION creation sequence that are in the Docker Hub

### CentOS 7
```
git clone https://github.com/luvres/hadoop.git
cd hadoop
docker build -t izone/hadoop .

docker build -t izone/hadoop:cos7 ./centos7/
docker build -t izone/hadoop:cos7-miniconda ./centos7/miniconda/
docker build -t izone/hadoop:cos7-ecosystem ./centos7/ecosystem/
docker build -t izone/hadoop:cos7-anaconda ./centos7/anaconda/
docker build -t izone/hadoop:cos7-mahout ./centos7/mahout/

docker build -t izone/hadoop:cluster ./centos7/cluster/
docker build -t izone/hadoop:datanode ./centos7/cluster/datanode/
```
### CentOS 6
```
git clone https://github.com/luvres/hadoop.git
cd hadoop
docker build -t izone/hadoop:cos6 ./centos6/
docker build -t izone/hadoop:cos6-miniconda ./centos6/miniconda/
docker build -t izone/hadoop:cos6-ecosystem ./centos6/ecosystem/
docker build -t izone/hadoop:cos6-anaconda ./centos6/anaconda/
docker build -t izone/hadoop:cos6-mahout ./centos6/mahout/

docker build -t izone/hadoop:cos6-cluster ./centos6/cluster/
docker build -t izone/hadoop:cos6-datanode ./centos6/cluster/datanode
```
### Alpine
```
git clone https://github.com/luvres/hadoop.git
cd hadoop
docker build -t izone/hadoop:alpine ./alpine/
docker build -t izone/hadoop:alpine-datanode ./alpine/datanode/
```
---
### Pull image latest (with CentOS 7)
```
docker pull izone/hadoop
```
#### Run pulled image (Optional flag "-test" to start with a PI test)
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-ti izone/hadoop:cos7 -test bash
```
#### Pull image with CentOS 6 (Same form as centos 7)
```
docker pull izone/hadoop:cos7
```
### Pull reduced image with Alpine (576.1 MB)
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
#### Build image
```
git clone https://github.com/luvres/hadoop.git
cd hadoop
docker build -t hadoop .
```
#### Build image with CentOS 6
```
docker build -t hadoop:cos6 ./centos6/
```
### Run built image
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-ti hadoop:cos7 bash
```
### Hadoop Browser
```
http://localhost:8088

http://localhost:50070
```
---
## Testing..

#### Create a Directory
```
hdfs dfs -mkdir /bigdata
```

#### List diretory
```
hadoop fs -ls /
```

#### Download a file csv
```
wget -c http://compras.dados.gov.br/contratos/v1/contratos.csv
```

#### Copy file to the HDFS directory created above
```
hadoop fs -copyFromLocal contratos.csv /bigdata
```

#### Read file
```
hadoop fs -cat /bigdata/contratos.csv
```
#### Test word count with mapreduce
```
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar wordcount /bigdata/contratos.csv /output
```

#### Read result
```
hdfs dfs -cat /output/*
```
---
## PySpark and Jupyter Notebook

#### Create a directory for notebooks and Include directory created above on flag "-v"
```
mkdir $HOME/notebooks
```
### Pull image with Miniconda
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-p 8888:8888 \
	-p 4040:4040 \
	-v $HOME/notebooks:/root/notebooks \
	-ti izone/hadoop:cos7-miniconda bash
```
### Pull image with Anaconda
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-p 8888:8888 \
	-p 4040:4040 \
	-v $HOME/notebooks:/root/notebooks \
	-ti izone/hadoop:cos7-anaconda bash
```
### Browser access

#### PySpark with Jupyter Notebook
```
http://localhost:8888
```
#### Spark management jobs
```
http://localhost:4040
```
### Build image
```
git clone https://github.com/luvres/hadoop.git
cd hadoop
```
#### PySpark and Miniconda
```
docker build -t hadoop:miniconda ./miniconda/
```
#### PySpark and Anaconda
```
docker build -t hadoop:cos7-anaconda ./centos7/anaconda/
```
---
## Hadoop Ecosystem
### (Zookeeper, HBase, Hive, Pig, Sqoop, Flume)

### Pull image
```
docker run --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8042:8042 \
	-p 50070:50070 \
	-p 8888:8888 \
	-p 4040:4040 \
	-v $HOME/notebooks:/root/notebooks \
	-d izone/hadoop:cos7-ecosystem
```
#### Access by Jupyter Notebook
```
http://localhost:8888/terminals/1

 sh-4.2# bash <enter>
```

