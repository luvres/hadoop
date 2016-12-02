FROM izone/hadoop:mahout
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN wget http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0/ambari.repo -O /etc/yum.repos.d/ambari.repo -O /etc/yum.repos.d/ambari.repo \
    && yum install -y ambari-server


# Ambari port
EXPOSE 8080
