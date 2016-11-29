FROM izone/hadoop
MAINTAINER Leonardo Loures <luvres@hotmail.com>


# Sqoop
ENV SQOOP_VERSION 1.4.6
RUN wget -c http://ftp.unicamp.br/pub/apache/sqoop/${SQOOP_VERSION}/sqoop-${SQOOP_VERSION}.bin__hadoop-2.0.4-alpha.tar.gz \
    && tar -xzf sqoop-${SQOOP_VERSION}.bin__hadoop-2.0.4-alpha.tar.gz \
    && mv sqoop-${SQOOP_VERSION}.bin__hadoop-2.0.4-alpha /usr/local/ \
    && ln -s /usr/local/sqoop-${SQOOP_VERSION}.bin__hadoop-2.0.4-alpha/ /opt/sqoop

ENV SQOOP_HOME=/opt/sqoop
ENV PATH=$PATH:$SQOOP_HOME/bin
ENV ACCUMULO_HOME=/opt/sqoop/accumulo
ENV HCAT_HOME=/opt/sqoop/hcatalog

ADD sqoop-env.sh /opt/sqoop/conf/sqoop-env.sh

RUN mkdir /usr/local/jdbc \
    && wget -c https://github.com/luvres/jdbc/raw/master/mysql-connector-java-5.1.40-bin.jar -O /usr/local/jdbc/mysql-connector-java-5.1.40-bin.jar \
    && wget -c https://github.com/luvres/jdbc/raw/master/mariadb-java-client-1.4.6.jar -O /usr/local/jdbc/mariadb-java-client-1.4.6.jar \
    && wget -c https://github.com/luvres/jdbc/raw/master/ojdbc7.jar -O /usr/local/jdbc/ojdbc7.jar \
    && wget -c https://github.com/luvres/jdbc/raw/master/postgresql-9.4.1212.jar -O /usr/local/jdbc/postgresql-9.4.1212.jar

RUN ln -s /usr/local/jdbc/mysql-connector-java-5.1.40-bin.jar /opt/sqoop/lib/mysql-connector-java-5.1.40-bin.jar \
    && ln -s /usr/local/jdbc/mariadb-java-client-1.4.6.jar /opt/sqoop/lib/mariadb-java-client-1.4.6.jar \
    && ln -s /usr/local/jdbc/ojdbc7.jar /opt/sqoop/lib/ojdbc7.jar \
    && ln -s /usr/local/jdbc/postgresql-9.4.1212.jar /opt/sqoop/lib/postgresql-9.4.1212.jar


# Flume
ENV FLUME_VERSION 1.7.0
RUN wget -c http://ftp.unicamp.br/pub/apache/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz \
    && tar -xzf apache-flume-${FLUME_VERSION}-bin.tar.gz \
    && mv apache-flume-${FLUME_VERSION}-bin /usr/local/ \
    && ln -s /usr/local/apache-flume-${FLUME_VERSION}-bin/ /opt/flume

ADD flume-env.sh /opt/flume/conf/flume-env.sh

ENV FLUME_HOME=/opt/flume
ENV PATH=$PATH:$FLUME_HOME/bin
ENV CLASSPATH=#CLASSPATH:$FLUME_HOME/lib/*

