#!/bin/bash
set -e

nohup /usr/bin/supervisord -c /etc/supervisord.conf &
sleep 10


echo "••• `date` Iniciando o HDFS - NameNode DataNodes"
start-dfs.sh
sleep 10


echo "••• `date` Iniciando o YARN -  Resource Manager"
start-yarn.sh
sleep 10

$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver


#echo "127.0.0.1       $HOSTNAME" >>/etc/hosts

if [[ $1 == "bash" ]]; then
  echo "••• `date` Iniciando a Shell Bash"
  /bin/bash
fi

if [[ $1 == "bash" ]]; then
  echo "••• `date` Iniciando a Shell Bash"
  /bin/bash
fi


sleep 1000000000000
