FROM centos:6.8
MAINTAINER Leonardo Loures <luvres@hotmail.com>

USER root

RUN sed -i -e 's/^tsflags=nodocs/#tsflags=nodocs/g' /etc/yum.conf
RUN yum install -y epel-release
RUN yum install -y dhclient openssh-server openssh-clients supervisor lsof which gcc
RUN yum install -y sudo tar wget ntp passwd

# update libselinux.
# see https://github.com/sequenceiq/hadoop-docker/issues/14
RUN yum update -y libselinux

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN /etc/init.d/sshd start

# Ambari
#RUN curl -L http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -o curl -L http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -o ~/1uvr3z/R/RStudio/ambari.repo \
#    && yum install -y ambari-server
RUN wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -O /etc/yum.repos.d/ambari.repo \
    && yum install -y ambari-server

# start the linux services
RUN service ntpd start
RUN service sshd start

### Java
#RUN yum install -y java-1.7.0-openjdk-devel
#RUN mkdir /usr/java
#RUN ln -s /etc/alternatives/java_sdk_1.7.0 /usr/java/default

# Java 8
RUN yum install -y java
RUN wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz

RUN tar -xzf jdk-8u112-linux-x64.tar.gz \
    && mv jdk1.8.0_112/ /usr/local/ \
    && ln -s /usr/local/jdk1.8.0_112/ /opt/jdk
ENV JAVA_HOME=/opt/jdk
ENV PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
RUN rm jdk-8u112-linux-x64.tar.gz

#Ambari port
EXPOSE 8080

