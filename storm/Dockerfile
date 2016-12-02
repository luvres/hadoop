FROM izone/hadoop:ecosystem
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Storm
ENV STORM_VERSION 1.0.2
RUN wget -c http://ftp.unicamp.br/pub/apache/storm/apache-storm-${STORM_VERSION}/apache-storm-${STORM_VERSION}.tar.gz \
    && tar -xzf apache-storm-${STORM_VERSION}.tar.gz \
    && rm apache-storm-${STORM_VERSION}.tar.gz \
    && mv apache-storm-${STORM_VERSION} /usr/local/ \
    && ln -s /usr/local/apache-storm-${STORM_VERSION}/ /opt/storm \
    && mkdir /opt/storm/data
ENV STORM_HOME=/opt/storm
ENV PATH=$PATH:$STORM_HOME/bin
ADD storm.yaml /opt/storm/conf/storm.yaml

ADD start.sh /start.sh
RUN chmod +x start.sh

# Storm ports
EXPOSE 8080

