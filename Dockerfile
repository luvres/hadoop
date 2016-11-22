FROM centos
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN yum install -y \
    openssh-server openssh-clients \
    bzip2 unzip rsync wget net-tools java sudo which \
    && yum update -y

# SSH Key Passwordless
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa \
    && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
    && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''
RUN sed -i '/StrictHostKeyChecking/s/#//g' /etc/ssh/ssh_config \
    && sed -i '/StrictHostKeyChecking/s/ask/no/g' /etc/ssh/ssh_config

# Java
RUN wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz \
    && tar -xzf jdk-8u112-linux-x64.tar.gz \
    && mv jdk1.8.0_112/ /usr/local/ \
    && ln -s /usr/local/jdk1.8.0_112/ /opt/jdk
#   && ln -s /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.111-1.b15.el7_2.x86_64/ /opt/jre

ENV JAVA_HOME=/opt/jdk
#ENV JRE_HOME=/opt/jre
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
ADD hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD start.sh /start.sh
RUN hdfs namenode -format

## Anaconda3 -> https://www.continuum.io/downloads
# RUN wget -c https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh \
#    && /bin/bash Anaconda3-4.2.0-Linux-x86_64.sh -b -p /usr/local/anaconda3 \
#    && ln -s /usr/local/anaconda3/ /opt/anaconda3 \
#    && rm Anaconda3-4.2.0-Linux-x86_64.sh
# ENV PATH=/opt/anaconda3/bin:$PATH

# Miniconda3
#RUN wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#    && /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local/miniconda3 \
#    && ln -s /usr/local/miniconda3/ /opt/miniconda3
#ENV PATH=/opt/miniconda3/bin:$PATH
#RUN conda install jupyter -y \
#    && rm Miniconda3-latest-Linux-x86_64.sh


# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000

# Mapred ports
EXPOSE 10020 19888

# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088

# Jupyter Notebook ports
EXPOSE 8888

#Other ports
EXPOSE 49707 22 2122

# Add Tini
ENV TINI_VERSION v0.13.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--", "/start.sh"]



