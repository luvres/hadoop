# Hadoop 2.7.3 pseudo distributed mode and Jupyter Notebook with CentOS 6
```
docker build -t hadoop:2.7.3 .

docker run --rm --name Hadoop -h hadoop \
	-p 8088:8088 \
	-p 8888:8888 \
	-ti hadoop:2.7.3 bash
```
# Hadoop Browser
```
http://localhost:8888
```

# Notebook Access
```
jupyter notebook --ip='0.0.0.0' --no-browser

http://localhost:8888
```

### Testar o Hadoop

#Criar um diretorio
```
hdfs dfs -mkdir /bigdata
```
#Listar diretorio
```
hadoop fs -ls /
```
# Baixar um arquivo csv
```
wget -c http://compras.dados.gov.br/contratos/v1/contratos.csv
```

#Copia arquivo para diretírio HDFS criado
```
hadoop fs -copyFromLocal contratos.csv /bigdata
```
# Ler arquivo
```
hadoop fs -cat /bigdata/contratos.csv
```
# Teste contar palavras com mapreduce
```
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar wordcount /bigdata/contratos.csv /output
```

# Ler resultado
```
hdfs dfs -cat /output/*
```
