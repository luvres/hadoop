## Hadoop 2.7.3 pseudo distributed mode and Jupyter Notebook with CentOS 7
---
### Build image
```
git clone https://github.com/luvres/hadoop.git
cd hadoop
docker build -t hadoop .
```
#### Build image with CentOS 6
```
docker build -t hadoop:2.7.3 ./centos6/
```
### Pull image
```
docker pull izone/hadoop
```
### Pull image with CentOS 6
```
docker pull izone/hadoop:2.7.3
```
#### Run image
```
docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8888:8888 \
	-p 8042:8042 \
	-ti izone/hadoop bash
```
#### Hadoop Browser
```
http://localhost:8088
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
## Jupyter Notebook

#### Command in container
```
jupyter notebook --ip='0.0.0.0' --no-browser
```
#### Jupyter Notebook Browser access
```
http://localhost:8888
```
