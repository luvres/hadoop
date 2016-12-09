#!/bin/bash

nodesSSH(){
  for i in `seq $((NODES))`
  do
    sshpass -p $RPASS ssh-copy-id -i $HOME/.ssh/id_dsa.pub ${HOSTNODE}$i # Copy key to the nodes
    echo ${HOSTNODE}$i >>/etc/machines # Create "machines" file with the names of nodes
  done
}; nodesSSH

hostsNodes(){
  for i in `seq $((NODES))`
  do
    scp /etc/hosts ${HOSTNODE}$i:/etc/hosts
    scp /opt/hadoop/etc/hadoop/hadoop-env.sh ${HOSTNODE}$i:/opt/hadoop/etc/hadoop/hadoop-env.sh
    scp /opt/hadoop/etc/hadoop/core-site.xml ${HOSTNODE}$i:/opt/hadoop/etc/hadoop/core-site.xml
    scp /opt/hadoop/etc/hadoop/mapred-site.xml ${HOSTNODE}$i:/opt/hadoop/etc/hadoop/mapred-site.xml
    scp /opt/hadoop/etc/hadoop/yarn-site.xml ${HOSTNODE}$i:/opt/hadoop/etc/hadoop/yarn-site.xml
  done
}; hostsNodes

confFiles(){
  echo $HOSTNAME >/opt/hadoop/etc/hadoop/slaves
  cat /etc/machines >>/opt/hadoop/etc/hadoop/slaves
  sed -i "s/NAMENODE/$HOSTNAME/" /opt/hadoop/etc/hadoop/core-site.xml
  sed -i "s/NAMENODE/$HOSTNAME/" /opt/hadoop/etc/hadoop/yarn-site.xml
}; confFiles
