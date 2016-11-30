FROM izone/hadoop:ecosystem
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Mahout
ENV MAHOUT_VERSION 0.12.2
RUN wget -c http://ftp.unicamp.br/pub/apache/mahout/${MAHOUT_VERSION}/apache-mahout-distribution-${MAHOUT_VERSION}.tar.gz \
    && tar -xzf apache-mahout-distribution-${MAHOUT_VERSION}.tar.gz \
    && rm apache-mahout-distribution-${MAHOUT_VERSION}.tar.gz \
    && mv apache-mahout-distribution-${MAHOUT_VERSION} /usr/local/mahout-${MAHOUT_VERSION} \
    && ln -s /usr/local/mahout-${MAHOUT_VERSION}/ /opt/mahout
ENV MAHOUT_HOME=/opt/mahout
ENV PATH=$PATH:$MAHOUT_HOME/bin

