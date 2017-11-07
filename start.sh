#!/bin/bash

echo " "
echo -e "\e[00;37m*\e[00m `date` \e[00;37mStarting Supervidord\e[00m"
nohup /usr/bin/supervisord -c /etc/supervisord.conf &
sleep 3

#/etc/init.d/ssh start

echo " "
echo -e "\e[01;37m*\e[00m `date` \e[01;37mStarting HDFS - NameNode DataNodes\e[00m"
start-dfs.sh

echo " "
echo -e "\e[01;37m*\e[00m `date` \e[01;37mStarting YARN - Resource Manager\e[00m"
start-yarn.sh

$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver


if [[ $1 == "bash" ]]; then
  echo " "
  echo -e "\e[01;32m*\e[00m `date` \e[01;32mShell Bash\e[00m"
  /bin/bash
fi

if [[ $1 == "-test" ]]; then
  echo " "
  echo -e "\e[00;33m*\e[00m `date` \e[00;33mtesting Hadoop MapReduce ..\e[00m"
  hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.2.jar pi 16 1000
fi

if [[ $2 == "bash" ]]; then
  echo " "
  echo -e "\e[01;32m*\e[00m `date` \e[01;32mShell Bash\e[00m"
  /bin/bash
fi


sleep 31557600
