#!/bin/bash

/usr/sbin/sshd
start-dfs.sh
start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver


#echo "127.0.0.1       $HOSTNAME" >>/etc/hosts

if [[ $1 == "bash" ]]; then
  /bin/bash
fi
