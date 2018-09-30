FROM izone/hadoop:julia
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Zookeeper
ENV ZOOKEEPER_VERSION=3.4.13 \
    ZOOKEEPER_HOME=/opt/zookeeper \
    PATH=$PATH:$ZOOKEEPER_HOME/bin
ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg
RUN \
    curl http://ftp.unicamp.br/pub/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION}/ /opt/zookeeper \
    && mkdir /opt/zookeeper/data

    
# HBase
ENV HBASE_VERSION=2.1.0 \
    HBASE_HOME=/opt/hbase \
    PATH=$PATH:$HBASE_HOME/bin
ADD hbase-env.sh $HBASE_HOME/conf/hbase-env.sh
ADD hbase-site.xml $HBASE_HOME/conf/hbase-site.xml
RUN \
    curl http://ftp.unicamp.br/pub/apache/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz | tar -xzf - -C /usr/local/ \
    && rm -fR /usr/local/hbase-${HBASE_VERSION}/docs \
    && ln -s /usr/local/hbase-${HBASE_VERSION}/ /opt/hbase

    
# Hive
ENV HIVE_VERSION=2.3.3 \
    HIVE_HOME=/opt/hive \
    PATH=$PATH:$HIVE_HOME/bin \
    CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:. \
    CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.
ADD hive-env.sh $HIVE_HOME/conf/hive-env.sh
ADD hive-default.xml $HIVE_HOME/conf/hive-default.xml
RUN \
    curl http://ftp.unicamp.br/pub/apache/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/apache-hive-${HIVE_VERSION}-bin/ /opt/hive

    
# Pig
ENV PIG_VERSION=0.17.0 \
    PIG_HOME=/opt/pig \
    PATH=$PATH:$PIG_HOME/bin \
    PIG_CLASSPATH=$HADOOP_HOME/conf
RUN \
    curl http://ftp.unicamp.br/pub/apache/pig/pig-${PIG_VERSION}/pig-${PIG_VERSION}.tar.gz | tar -xzf - -C /usr/local/ \
    && rm -fR /usr/local/pig-${PIG_VERSION}/docs \
    && ln -s /usr/local/pig-${PIG_VERSION}/ /opt/pig

    
# Sqoop
ENV SQOOP_VERSION=1.4.7 \
    SQOOP_HOME=/opt/sqoop \
    PATH=$PATH:$SQOOP_HOME/bin \
    ACCUMULO_HOME=/opt/sqoop/accumulo \
    HCAT_HOME=/opt/sqoop/hcatalog
ADD sqoop-env.sh /opt/sqoop/conf/sqoop-env.sh
RUN \
    curl http://ftp.unicamp.br/pub/apache/sqoop/${SQOOP_VERSION}/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0-alpha/ /opt/sqoop \
    && mkdir /opt/sqoop/hcatalog /opt/sqoop/accumulo \
  \
    && mkdir -p /opt/sqoop/lib \
    && ln -s /usr/local/jdbc/mysql-connector-java-5.1.47-bin.jar /opt/sqoop/lib/mysql-connector.jar  \
    && ln -s /usr/local/jdbc/mariadb-java-client-2.2.6.jar /opt/sqoop/lib/mariadb-connector.jar \
    && ln -s /usr/local/jdbc/ojdbc7.jar /opt/sqoop/lib/ojdbc7.jar \
    && ln -s /usr/local/jdbc/ojdbc6.jar /opt/sqoop/lib/ojdbc6.jar \
    && ln -s /usr/local/jdbc/postgresql-42.2.5.jar /opt/sqoop/lib/postgresql-connector.jar

    
# Flume
ENV FLUME_VERSION=1.8.0 \
    FLUME_HOME=/opt/flume \
    PATH=$PATH:$FLUME_HOME/bin \
    CLASSPATH=$CLASSPATH:$FLUME_HOME/lib/*
ADD flume-env.sh /opt/flume/conf/flume-env.sh
RUN \
    curl http://ftp.unicamp.br/pub/apache/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz | tar -xzf - -C /usr/local/ \
    && rm -fR /usr/local/apache-flume-${FLUME_VERSION}-bin/docs \
    && ln -s /usr/local/apache-flume-${FLUME_VERSION}-bin/ /opt/flume


# Mahout
ENV MAHOUT_VERSION=0.13.0 \
    MAHOUT_HOME=/opt/mahout \
    PATH=$PATH:$MAHOUT_HOME/bin
ADD start.sh /etc/start.sh
RUN \
    curl http://ftp.unicamp.br/pub/apache/mahout/${MAHOUT_VERSION}/apache-mahout-distribution-${MAHOUT_VERSION}.tar.gz | tar -xzf - -C /usr/local/ \
    && rm -fR /usr/local/apache-mahout-distribution-${MAHOUT_VERSION}/docs \
    && ln -s /usr/local/apache-mahout-distribution-${MAHOUT_VERSION}/ /opt/mahout \
  \
    && chmod +x /etc/start.sh

    
# Bash colors
RUN \
    sed -i '/PS1/d' $HOME/.bashrc \
    && echo 'export PS1="${RESET}[${RED}\u${RESET}@${YELLOW}\h${RESET}:${BLUE}\w${RESET}]# ${RESET}"' >>$HOME/.bashrc

    
# HBase ports
EXPOSE 60010 60030
