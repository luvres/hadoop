#!/bin/bash

service sshd start
start-dfs.sh
start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver


if [[ $1 == "bash" ]]; then
  /bin/bash
fi
