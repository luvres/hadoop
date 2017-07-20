FROM alpine
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN apk update && apk upgrade \
    && apk add openssh rsync curl procps supervisor vim bash ncurses \
    && rm -rf /var/cache/apk/*

# SSH Key Passwordless
RUN /usr/bin/ssh-keygen -A \
    && ssh-keygen -q -N "" -t rsa -f /etc/ssh/id_rsa \
    && cp /etc/ssh/id_rsa.pub /etc/ssh/authorized_keys
RUN mkdir -p /root/.ssh \
    && cp /etc/ssh/ssh_config /root/.ssh/config \
    && cp /etc/ssh/authorized_keys /root/.ssh/authorized_keys \
    && cp /etc/ssh/id_rsa /root/.ssh/id_rsa
RUN sed -i '/StrictHostKeyChecking/s/ask/no/g' /etc/ssh/ssh_config \
    && sed -i '/StrictHostKeyChecking/s/#//g' /etc/ssh/ssh_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ENV RPASS=@p4sS_-_#sECURITy*Cre4t3+bigZone
RUN echo root:$RPASS | chpasswd

# glibc
ENV GLIB_VERSION 2.25-r0
RUN apk --update add ca-certificates \
    && curl -Ls https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIB_VERSION}/glibc-${GLIB_VERSION}.apk > /tmp/glibc-${GLIB_VERSION}.apk \
    && apk add --allow-untrusted /tmp/glibc-${GLIB_VERSION}.apk

# Java
RUN JAVA_VERSION_MAJOR=8 && \
    JAVA_VERSION_MINOR=141 && \
    JAVA_VERSION_BUILD=15 && \
    JAVA_PACKAGE=jdk && \
    URL=336fa29ff2bb4ef291e347e091f7f4a7 && \
    mkdir /opt && \
    curl -jkSLH "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${URL}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
    | tar -xzf - -C /opt \
    && ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk \
    && rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /opt/jdk/lib/*javafx* \
           /opt/jdk/jre/plugin \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/bin/jjs \
           /opt/jdk/jre/bin/orbd \
           /opt/jdk/jre/bin/pack200 \
           /opt/jdk/jre/bin/policytool \
           /opt/jdk/jre/bin/rmid \
           /opt/jdk/jre/bin/rmiregistry \
           /opt/jdk/jre/bin/servertool \
           /opt/jdk/jre/bin/tnameserv \
           /opt/jdk/jre/bin/unpack200 \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/jre/lib/amd64/libprism_*.so \
           /opt/jdk/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/jre/lib/amd64/libglass.so \
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/jre/lib/amd64/libjfx*.so \
           /opt/jdk/jre/lib/ext/jfxrt.jar \
           /opt/jdk/jre/lib/ext/nashorn.jar \
           /opt/jdk/jre/lib/oblique-fonts \
           /opt/jdk/jre/lib/plugin.jar \
           /tmp/* /var/cache/apk/*
ENV JAVA_HOME=/opt/jdk
ENV PATH=${PATH}:${JAVA_HOME}/bin:${JAVA_HOME}/sbin

# Hadoop
ENV HADOOP_VERSION 2.8.0
RUN curl http://ftp.unicamp.br/pub/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar -xzf - -C /usr/local/ \
    && rm -fR /usr/local/hadoop-${HADOOP_VERSION}/share/doc \
              /usr/local/hadoop-${HADOOP_VERSION}/share/hadoop/common/jdiff \
    && ln -s /usr/local/hadoop-${HADOOP_VERSION}/ /opt/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Spark
ENV SPARK_VERSION 2.1.1
RUN curl http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.7/ /opt/spark
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin

# HBase
ENV HBASE_VERSION 1.3.1
RUN curl http://ftp.unicamp.br/pub/apache/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz | tar -xzf - -C /usr/local/ \
    && rm -fR /usr/local/hbase-${HBASE_VERSION}/docs \
    && ln -s /usr/local/hbase-${HBASE_VERSION}/ /opt/hbase
ENV HBASE_HOME=/opt/hbase
ENV PATH=$PATH:$HBASE_HOME/bin

# Configurations Fully Distributed
ADD start.sh /etc/start.sh
RUN chmod +x /etc/start.sh \
    && mkdir -p /tmp/hdfs/datanode

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000

# Mapred ports
EXPOSE 10020 19888

# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088


ENTRYPOINT ["/etc/start.sh"]

