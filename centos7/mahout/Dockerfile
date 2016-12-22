FROM izone/hadoop:cos7-anaconda
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Zookeeper
ENV ZOOKEEPER_VERSION 3.4.9
RUN curl http://ftp.unicamp.br/pub/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION}/ /opt/zookeeper \
    && mkdir /opt/zookeeper/data
ENV ZOOKEEPER_HOME=/opt/zookeeper
ENV PATH=$PATH:$ZOOKEEPER_HOME/bin
ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg

# HBase
ENV HBASE_VERSION 1.2.4
RUN curl http://ftp.unicamp.br/pub/apache/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/hbase-${HBASE_VERSION}/ /opt/hbase
ENV HBASE_HOME=/opt/hbase
ENV PATH=$PATH:$HBASE_HOME/bin
ADD hbase-env.sh $HBASE_HOME/conf/hbase-env.sh
ADD hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

# Hive
ENV HIVE_VERSION 2.1.1
RUN curl http://ftp.unicamp.br/pub/apache/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/apache-hive-${HIVE_VERSION}-bin/ /opt/hive
ENV HIVE_HOME=/opt/hive
ENV PATH=$PATH:$HIVE_HOME/bin
ENV CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:.
ENV CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.
ADD hive-env.sh $HIVE_HOME/conf/hive-env.sh
ADD hive-default.xml $HIVE_HOME/conf/hive-default.xml

# Pig
ENV PIG_VERSION 0.16.0
RUN curl http://ftp.unicamp.br/pub/apache/pig/pig-${PIG_VERSION}/pig-${PIG_VERSION}.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/pig-${PIG_VERSION}/ /opt/pig
ENV PIG_HOME=/opt/pig
ENV PATH=$PATH:$PIG_HOME/bin
ENV PIG_CLASSPATH=$HADOOP_HOME/conf

# Sqoop
ENV SQOOP_VERSION 1.4.6
RUN curl http://ftp.unicamp.br/pub/apache/sqoop/${SQOOP_VERSION}/sqoop-${SQOOP_VERSION}.bin__hadoop-2.0.4-alpha.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/sqoop-${SQOOP_VERSION}.bin__hadoop-2.0.4-alpha/ /opt/sqoop \
    && mkdir /opt/sqoop/hcatalog /opt/sqoop/accumulo
ENV SQOOP_HOME=/opt/sqoop
ENV PATH=$PATH:$SQOOP_HOME/bin
ENV ACCUMULO_HOME=/opt/sqoop/accumulo
ENV HCAT_HOME=/opt/sqoop/hcatalog
ADD sqoop-env.sh /opt/sqoop/conf/sqoop-env.sh
RUN ln -s /usr/local/jdbc/mysql-connector-java-5.1.40-bin.jar /opt/sqoop/lib/mysql-connector.jar \
    && ln -s /usr/local/jdbc/mariadb-java-client-1.4.6.jar /opt/sqoop/lib/mariadb-connector.jar \
    && ln -s /usr/local/jdbc/ojdbc7.jar /opt/sqoop/lib/ojdbc7.jar \
    && ln -s /usr/local/jdbc/postgresql-9.4.1212.jar /opt/sqoop/lib/postgresql-connector.jar

# Flume
ENV FLUME_VERSION 1.7.0
RUN curl http://ftp.unicamp.br/pub/apache/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/apache-flume-${FLUME_VERSION}-bin/ /opt/flume
ADD flume-env.sh /opt/flume/conf/flume-env.sh
ENV FLUME_HOME=/opt/flume
ENV PATH=$PATH:$FLUME_HOME/bin
ENV CLASSPATH=#CLASSPATH:$FLUME_HOME/lib/*

# Mahout
ENV MAHOUT_VERSION 0.12.2
RUN curl http://ftp.unicamp.br/pub/apache/mahout/${MAHOUT_VERSION}/apache-mahout-distribution-${MAHOUT_VERSION}.tar.gz | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/apache-mahout-distribution${MAHOUT_VERSION}/ /opt/mahout
ENV MAHOUT_HOME=/opt/mahout
ENV PATH=$PATH:$MAHOUT_HOME/bin

ADD start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

# Bash colors
RUN sed -i '/PS1/d' $HOME/.bashrc \
    && echo 'export PS1="${RESET}[${RED}\u${RESET}@${YELLOW}\h${RESET}:${BLUE}\w${RESET}]# ${RESET}"' >>$HOME/.bashrc

