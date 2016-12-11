#!/bin/bash

NET=172.32.255
SUBNET=16/28
RANGE=16/28
docker network rm znet &>/dev/null
docker network create --subnet ${NET}.${SUBNET} --ip-range=${NET}.${RANGE} znet &>/dev/null # 18-30
IP=30
unset HOSTS

### Functions
arg00(){
  NODE=node-0
  for i in `seq $((NODES))`
  do
  HOSTS="$HOSTS --add-host ${NODE}$i:${NET}.$((${IP}-$i))"
  docker run --name Node-0$i -h ${NODE}$i \
  --net znet --ip ${NET}.$((${IP}-$i)) \
  -d izone/hadoop:datanode
  done

  NAMENODE=hadoop
  CONTAINER=Hadoop
  docker run --rm --name ${CONTAINER} -h ${NAMENODE} \
  --net znet --ip ${NET}.${IP} \
  -e NODES=$NODES \
  $HOSTS \
  -p 8088:8088 \
  -p 8042:8042 \
  -p 50070:50070 \
  -p 8888:8888 \
  -p 4040:4040 \
  -v $HOME/notebooks:/root/notebooks \
  -ti izone/hadoop:cluster bash
}

arg01(){
  if [ $1 -gt 0 ] && [ $1 -lt 10 ]; then
    NODES=$1 # Max -> 12 nodes
    arg00
  else
    echo "Number of nodes: 1 to 9"
  fi
  if [ $1 == "pseudo" ]; then
    echo $@
  fi
}
arg02(){
  if [ $# == 2 ]; then
    if [ $2 == "-db" ]; then
      # MariaDB
      CONTAINER=MariaDB
      HOST_MARIADB=mariadb
      docker run --name ${CONTAINER} -h ${HOST_MARIADB} \
      --net znet --ip ${NET}.$((${IP}-12)) \
      -p 3306:3306 \
      -e MYSQL_ROOT_PASSWORD=maria \
      -d mariadb
      HOSTS="$HOSTS --add-host ${HOST_MARIADB}:${NET}.$((${IP}-12))"
      # OracleXE
      CONTAINER=OracleXE
      HOST_ORACLE=oraclexe
      docker run --name OracleXE -h oraclexe \
      --net znet --ip ${NET}.$((${IP}-11)) \
      -p 1521:1521 \
      -d izone/oracle
      HOSTS="$HOSTS --add-host ${HOST_ORACLE}:${NET}.$((${IP}-11))"
      arg01 $@
    else
      echo 'Third argument of being "-db"'
    fi
  fi
}
stop(){
  # Stop nodes
  for i in {1..12}
  do
    docker stop Node-0$i
    docker rm Node-0$i
  done &>/dev/null
  # Stop namenode
  CONTAINER=Hadoop
  docker stop ${CONTAINER}
  docker rm ${CONTAINER}
  # Stop Mariadb
  CONTAINER=MariaDB
  docker stop ${CONTAINER}
  docker rm ${CONTAINER}
  # Stop Oracle
  CONTAINER=OracleXE
  docker stop ${CONTAINER}
  docker rm ${CONTAINER}
}
pseudo(){
  NAMENODE=hadoop
  CONTAINER=Hadoop
  docker run --rm --name ${CONTAINER} -h ${NAMENODE} \
  -p 8088:8088 \
  -p 8042:8042 \
  -p 50070:50070 \
  -p 8888:8888 \
  -p 4040:4040 \
  -v $HOME/notebooks:/root/notebooks \
  -ti izone/hadoop:mahout bash
}


### Arguments
if [ $# == 0 ]; then
  NODES=1 # Max -> 12 nodes
  unset HOSTS
  arg00
fi

if [ $# == 1 ]; then
  case $1 in
    pseudo) pseudo ;;
      stop) stop ;;
         *) arg01 $@ ;;
  esac
fi

if [ $# == 2 ]; then
  arg02 $@
fi

