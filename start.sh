#!/bin/bash
set -e

nohup /usr/bin/supervisord -c /etc/supervisord.conf &
sleep 10

echo -e "• `date` \e[01;37mStarting HDFS - NameNode DataNodes\e[00m"
start-dfs.sh
sleep 10

echo -e "• `date` \e[01;37mStarting YARN - Resource Manager\e[00m"
start-yarn.sh
sleep 10

$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver


#echo "127.0.0.1       $HOSTNAME" >>/etc/hosts

if [[ $1 == "bash" ]]; then
  echo "••• `date` Shell Bash"
  /bin/bash
fi

if [[ $1 == "bash" ]]; then
  echo "••• `date` Shell Bash"
  /bin/bash
fi


sleep 1000000000000
