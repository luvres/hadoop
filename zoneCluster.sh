#!/bin/bash

arg01(){
  if [ $1 -gt 0 ] && [ $1 -lt 10 ]; then
    echo $@
  else
    echo "1 a 9"
  fi
  if [ $1 == "pseudo" ]; then
    echo $@
  fi
}
arg02(){
  if [ $# == 2 ]; then
    if [ $2 == "-db" ]; then
      arg01 $@
    else
      echo "ARg 3 deve ser -db"
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
NAMENODE=hadoop
CONTAINER=Hadoop
docker stop ${CONTAINER}
docker rm ${CONTAINER}
}

if [ $# == 0 ]; then

  NET=172.32.255
  SUBNET=16/28
  RANGE=16/28
  docker network rm znet &>/dev/null
  docker network create --subnet ${NET}.${SUBNET} --ip-range=${NET}.${RANGE} znet &>/dev/null # 18-30

  NODES=1 # Max -> 12 nodes
  NODE=node-0
  IP=30
  unset HOSTS
  for i in `seq $((NODES))`
  do
  HOSTS="$HOSTS  --add-host ${NODE}$i:${NET}.$((${IP}-$i))"
  docker run --name Node-0$i -h ${NODE}$i \
  --net znet --ip ${NET}.$((${IP}-$i)) \
  -d izone/hadoop:datanode
  done

  NAMENODE=hadoop
  CONTAINER=Hadoop
  docker run --rm --name ${CONTAINER} -h ${NAMENODE} \
  --net znet --ip ${NET}.${IP} \
  $HOSTS \
  -p 8088:8088 \
  -p 8042:8042 \
  -p 50070:50070 \
  -p 8888:8888 \
  -p 4040:4040 \
  -v $HOME/notebooks:/root/notebooks \
  -ti izone/hadoop:cluster bash
fi

if [ $# == 1 ]; then
  case $1 in
    pseudo) echo $1 ;;
      stop) stop ;;
         *) arg01 $@ ;;
  esac
fi

if [ $# == 2 ]; then
  arg02 $@
fi

