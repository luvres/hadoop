#!/bin/bash

/usr/sbin/sshd

echo -e "• `date` \e[01;37mStarting HDFS - NameNode DataNodes\e[00m"
start-dfs.sh

echo -e "• `date` \e[01;37mStarting YARN - Resource Manager\e[00m"
start-yarn.sh

$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver


if [[ $1 == "bash" ]]; then
  echo -e "• `date` \e[01;32mShell Bash\e[00m"
  /bin/bash
fi

if [[ $1 == "-test" ]]; then
  echo " "
  echo -e "• `date` \e[00;33mTest Hadoop Mapreduce ..\e[00m"
  hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar pi 16 1000
fi

if [[ $2 == "bash" ]]; then
  echo -e "• `date` \e[01;32mShell Bash\e[00m"
  /bin/bash
fi

