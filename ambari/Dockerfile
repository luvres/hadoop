FROM izone/hadoop:mahout
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Ambari 
ENV AMBARI_VERSION 2.2.2.0
RUN wget http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/${AMBARI_VERSION}/ambari.repo -O /etc/yum.repos.d/ambari.repo -O /etc/yum.repos.d/ambari.repo \
    && yum install -y ambari-server

# RUN ambari-server setup --silent --java-home $JAVA_HOME \
#    && ambari-server start

# Ambari port
EXPOSE 8080
