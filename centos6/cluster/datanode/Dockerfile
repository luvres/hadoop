FROM centos:6.8
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN yum install -y \
    openssh-server openssh-clients \
    bzip2 unzip rsync wget net-tools java sudo \
    && yum update -y

# SSH Key Passwordless

# SSH Key Passwordless
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa \
    && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys \
    && echo 'StrictHostKeyChecking no' >>/etc/ssh/ssh_config
ENV RPASS=@p4sS_-_#sECURITy*Cre4t3+bigZone
RUN echo root:$RPASS | chpasswd

# Timezone
RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Java
RUN wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz \
    && tar -xzf jdk-8u112-linux-x64.tar.gz \
    && mv jdk1.8.0_112/ /usr/local/ \
    && ln -s /usr/local/jdk1.8.0_112/ /opt/jdk
ENV JAVA_HOME=/opt/jdk
ENV PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
RUN rm jdk-8u112-linux-x64.tar.gz

# Hadoop
ENV HADOOP_VERSION 2.7.3
RUN wget -c http://ftp.unicamp.br/pub/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && tar -xzf hadoop-${HADOOP_VERSION}.tar.gz \
    && mv hadoop-${HADOOP_VERSION} /usr/local/ \
    && ln -s /usr/local/hadoop-${HADOOP_VERSION}/ /opt/hadoop \
    && rm hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Spark
ENV SPARK_VERSION 2.0.2
RUN wget -c http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && tar xzf spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && rm spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop2.7 /usr/local/ \
    && ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.7/ /opt/spark
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin
ADD spark-env.sh $SPARK_HOME/conf/spark-env.sh

# Configurations Fully Distributed
RUN mkdir -p /tmp/hdfs/datanode
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000

# Mapred ports
EXPOSE 10020 19888

# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088

#Other ports
EXPOSE 49707 22 2122


ENTRYPOINT ["/etc/start.sh"]

