#!/bin/bash

nodesSSH(){
  for i in `seq $((NODES))`
  do
    echo "Configuring SSH ${HOSTNODE}$i"
    for f in $HOME/.ssh/id_rsa.pub $HOME/.ssh/id_dsa.pub
    do
      sshpass -p $RPASS ssh-copy-id -i $f ${HOSTNODE}$i # Copy key to the nodes
    done &>/dev/null
    echo ${HOSTNODE}$i >>/etc/machines # Create "machines" file with the names of nodes
  done
}; nodesSSH

confFiles(){
  echo $HOSTNAME >$HADOOP_HOME/etc/hadoop/slaves
  cat /etc/machines >>$HADOOP_HOME/etc/hadoop/slaves
  cat /etc/machines >>$SPARK_HOME/conf/slaves
  sed -i "s/NAMENODE/$HOSTNAME/" $HADOOP_HOME/etc/hadoop/core-site.xml
  sed -i "s/NAMENODE/$HOSTNAME/" $HADOOP_HOME/etc/hadoop/yarn-site.xml
  cat $HADOOP_HOME/etc/hadoop/slaves >$HBASE_HOME/conf/regionservers
  sed -i "s/NAMENODE/$HOSTNAME/" $HBASE_HOME/conf/hbase-site.xml
  sed -i "s/NAMENODE/$HOSTNAME/" $HBASE_HOME/conf/hbase-site_slave.xml
  sed -i "s/QUORUM/$(echo `cat /opt/hadoop/etc/hadoop/slaves` | sed 's/ /,/g')/" $HBASE_HOME/conf/hbase-site.xml
}; confFiles

hostsNodes(){
  HADOOP=$HADOOP_HOME/etc/hadoop
  SPARK=$SPARK_HOME/conf
  HBASE=$HBASE_HOME/conf
  for i in `seq $((NODES))`
  do
    echo "Configuring files ${HOSTNODE}$i"
    for f in /etc/hosts \
             ${HADOOP}/hadoop-env.sh \
             ${HADOOP}/hdfs-site.xml \ 
             ${HADOOP}/core-site.xml \
             ${HADOOP}/mapred-site.xml \
             ${HADOOP}/yarn-site.xml \
             ${SPARK}/spark-env.sh \
             ${HBASE}/hbase-site_slave.xml \
             ${HBASE}/hbase-env.sh
    do
      scp $f ${HOSTNODE}$i:$f
      ssh ${HOSTNODE}$i mv ${HBASE}/hbase-site_slave.xml ${HBASE}/hbase-site.xml
    done &>/dev/null
  done
}; hostsNodes
