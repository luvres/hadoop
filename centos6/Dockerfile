FROM centos:6.8
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN yum install -y \
    openssh-server openssh-clients \
    bzip2 unzip rsync wget net-tools java sudo \
    && yum update -y

# SSH Key Passwordless
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa \
    && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys \
    && echo 'StrictHostKeyChecking no' >>/etc/ssh/ssh_config

# Java
RUN wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz \
    && tar -xzf jdk-8u112-linux-x64.tar.gz \
    && mv jdk1.8.0_112/ /usr/local/ \
    && ln -s /usr/local/jdk1.8.0_112/ /opt/jdk \
    && rm jdk-8u112-linux-x64.tar.gz

ENV JAVA_HOME=/opt/jdk \
    PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

# Hadoop
ENV HADOOP_VERSION 2.7.3
RUN wget -c http://ftp.unicamp.br/pub/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && tar -xzf hadoop-${HADOOP_VERSION}.tar.gz \
    && mv hadoop-${HADOOP_VERSION} /usr/local/ \
    && ln -s /usr/local/hadoop-${HADOOP_VERSION}/ /opt/hadoop \
    && rm hadoop-${HADOOP_VERSION}.tar.gz

ENV HADOOP_HOME=/opt/hadoop \
    HADOOP_INSTALL=$HADOOP_HOME \
    HADOOP_COMMON_HOME=$HADOOP_HOME \
    HADOOP_MAPRED_HOME=$HADOOP_HOME \
    HADOOP_HDFS_HOME=$HADOOP_HOME \
    YARN_HOME=$HADOOP_HOME \
    PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Configurations Pseudo Distributed
ADD hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD start.sh /start.sh
RUN chmod +x start.sh
RUN hdfs namenode -format


# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000

# Mapred ports
EXPOSE 10020 19888

# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088

#Other ports
EXPOSE 49707 22 2122


ENTRYPOINT ["/start.sh"]
