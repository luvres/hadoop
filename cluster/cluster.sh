#!/bin/bash

nodesSSH(){
  for i in `seq $((NODES))`
  do
    echo "Configuring SSH ${HOSTNODE}$i"
    for f in $HOME/.ssh/id_dsa.pub
    do
      sshpass -p $RPASS ssh-copy-id -i $f ${HOSTNODE}$i # Copy key to the nodes
    done &>/dev/null
    echo ${HOSTNODE}$i >>/etc/machines # Create "machines" file with the names of nodes
  done
}; nodesSSH

confFiles(){
  echo $HOSTNAME >/opt/hadoop/etc/hadoop/slaves
  cat /etc/machines >>/opt/hadoop/etc/hadoop/slaves
  sed -i "s/NAMENODE/$HOSTNAME/" /opt/hadoop/etc/hadoop/core-site.xml
  sed -i "s/NAMENODE/$HOSTNAME/" /opt/hadoop/etc/hadoop/yarn-site.xml
}; confFiles

hostsNodes(){
  SOURCE=/opt/hadoop/etc/hadoop
  for i in `seq $((NODES))`
  do
    echo "Configuring files ${HOSTNODE}$i"
    for f in /etc/hosts ${SOURCE}/hadoop-env.sh ${SOURCE}/core-site.xml ${SOURCE}/mapred-site.xml ${SOURCE}/yarn-site.xml
    do
      scp $f ${HOSTNODE}$i:$f
      scp $f ${HOSTNODE}$i:$f
      scp $f ${HOSTNODE}$i:$f
      scp $f ${HOSTNODE}$i:$f
      scp $f ${HOSTNODE}$i:$f
    done &>/dev/null
  done
}; hostsNodes
