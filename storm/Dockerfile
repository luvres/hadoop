FROM izone/hadoop:ecosystem
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Storm
ENV STORM_VERSION 1.0.3
RUN curl http://ftp.unicamp.br/pub/apache/storm/apache-storm-${STORM_VERSION}/apache-storm-${STORM_VERSION}.tar.gz  | tar -xzf - -C /usr/local/ \
    && ln -s /usr/local/apache-storm-${STORM_VERSION}/ /opt/storm \
    && mkdir /opt/storm/data
ENV STORM_HOME=/opt/storm
ENV PATH=$PATH:$STORM_HOME/bin
ADD storm.yaml /opt/storm/conf/storm.yaml

ADD start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

# Storm ports
EXPOSE 8080

