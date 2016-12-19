FROM izone/hadoop:cos7-mahout
MAINTAINER Leonardo Loures <luvres@hotmail.com>

ENV NODES 1
ENV HOSTNODE node-0
ENV RPASS=@p4sS_-_#sECURITy*Cre4t3+bigZone

RUN yum install -y epel-release && yum update -y \
    && yum install -y pdsh sshpass \
    && yum update -y

# Scala
ENV SCALA_VERSION 2.12.1
RUN curl http://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz | tar xzf - -C /usr/local/ \
    && ln -s /usr/local/scala-${SCALA_VERSION} /opt/scala
ENV SCALA_HOME=/opt/scala
ENV PATH=$PATH:$SCALA_HOME/bin

# Spark
ADD spark-env.sh $SPARK_HOME/conf/spark-env.sh

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
