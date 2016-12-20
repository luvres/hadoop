FROM centos
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN yum install -y \
    openssh-server openssh-clients \
    bzip2 unzip rsync wget net-tools java sudo which python-setuptools \
    && yum update -y \
    && easy_install pip \
    && pip install supervisor

# SSH Key Passwordless
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa \
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys \
    && /usr/bin/ssh-keygen -A
RUN sed -i '/StrictHostKeyChecking/s/#//g' /etc/ssh/ssh_config \
    && sed -i '/StrictHostKeyChecking/s/ask/no/g' /etc/ssh/ssh_config

# Supervidor
ADD centos7/supervisord.conf /etc/supervisord.conf

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

# Configurations Pseudo Distributed
ADD centos7/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD centos7/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD centos7/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD centos7/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD centos7/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD centos7/start.sh /etc/start.sh
RUN chmod +x /etc/start.sh
RUN hdfs namenode -format

WORKDIR /root

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000

# Mapred ports
EXPOSE 10020 19888

# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088

#Other ports
EXPOSE 49707 22 2122


ENTRYPOINT ["/etc/start.sh"]
