FROM izone/hadoop
MAINTAINER Leonardo Loures <luvres@hotmail.com>


# Zookeeper
ENV ZOOKEEPER_VERSION 3.4.9
RUN wget -c http://ftp.unicamp.br/pub/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
    && tar -xzf zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
    && mv zookeeper-${ZOOKEEPER_VERSION} /usr/local/ \
    && ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION}/ /opt/zookeeper \
    && mkdir /opt/zookeeper/data

ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg

ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV PATH=$PATH:$ZOOKEEPER_HOME/bin


# HBase
ENV HBASE_VERSION 1.2.4
RUN wget -c http://ftp.unicamp.br/pub/apache/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz \
    && tar -xzf hbase-${HBASE_VERSION}-bin.tar.gz \
    && mv hbase-${HBASE_VERSION} /usr/local/ \
    && ln -s /usr/local/hbase-${HBASE_VERSION}/ /opt/hbase

ENV HBASE_HOME=/opt/hbase
ENV PATH=$PATH:$HBASE_HOME/bin

ADD hbase-env.sh $HBASE_HOME/conf/hbase-env.sh
ADD hbase-site.xml $HBASE_HOME/conf/hbase-site.xml


# Hive
ENV HIVE_VERSION 2.1.0
RUN wget -c http://ftp.unicamp.br/pub/apache/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && tar -xzf apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && mv apache-hive-${HIVE_VERSION}-bin /usr/local/ \
    && ln -s /usr/local/apache-hive-${HIVE_VERSION}-bin/ /opt/hive

ENV HIVE_HOME=/opt/hive
ENV PATH=$PATH:$HIVE_HOME/bin
ENV CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:.
ENV CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.

ADD hive-env.sh $HIVE_HOME/conf/hive-env.sh
ADD hive-default.xml $HIVE_HOME/conf/hive-default.xml


# Pig
ENV PIG_VERSION 0.16.0
RUN wget -c http://ftp.unicamp.br/pub/apache/pig/pig-${PIG_VERSION}/pig-${PIG_VERSION}.tar.gz \
    && tar -xzf pig-${PIG_VERSION}.tar.gz \
    && mv pig-${PIG_VERSION} /usr/local/ \
    && ln -s /usr/local/pig-${PIG_VERSION}/ /opt/pig

ENV PIG_HOME=/opt/pig
ENV PATH=$PATH:$PIG_HOME/bin
ENV PIG_CLASSPATH=$HADOOP_HOME/conf


ADD start.sh /start.sh
RUN chmod +x start.sh

