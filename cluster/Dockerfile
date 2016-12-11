FROM izone/hadoop:mahout
MAINTAINER Leonardo Loures <luvres@hotmail.com>

ENV NODES 1
ENV HOSTNODE node-0
ENV RPASS=@p4sS_-_#sECURITy*Cre4t3+bigZone

RUN yum install -y epel-release && yum update -y \
    && yum install -y pdsh sshpass \
    && yum update -y

# Configurations Fully Distributed
RUN mkdir -p /tmp/hdfs/{namenode,datanode}
ADD core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD cluster.sh /etc/cluster.sh
ADD start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

# Bash colors
RUN sed -i '/PS1/d' $HOME/.bashrc \
    && echo 'export PS1="${RESET}[${RED}\u${RESET}@${YELLOW}\h${RESET}:${BLUE}\w${RESET}]# ${GREEN}"' >>$HOME/.bashrc
