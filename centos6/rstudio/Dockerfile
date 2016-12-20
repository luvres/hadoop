FROM centos:6.8
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN yum -y install epel-release && yum update -y
RUN yum install -y locales java-1.8.0-openjdk-headless
RUN yum groupinstall -y "Development Tools"
RUN yum install -y wget git xml2 libxml2-devel curl-devel openssl-devel

WORKDIR /home/root
RUN yum install -y R

RUN wget http://cran.r-project.org/src/contrib/rJava_0.9-8.tar.gz
RUN R CMD INSTALL rJava_0.9-8.tar.gz
RUN R CMD javareconf \
	&& rm -rf rJava_0.9-8.tar.gz

ENV PATH /usr/lib/rstudio-server/bin/:$PATH 
ENV LANG en_US.UTF-8

RUN yum install -y openssl098e supervisor passwd pandoc

RUN curl -s https://download2.rstudio.org/rstudio-server-rhel-1.0.44-x86_64.rpm -o rstudio.rpm \
    && yum install -y --nogpgcheck rstudio.rpm \
    && rm rstudio.rpm

RUN groupadd rstudio \
	&& useradd -g rstudio rstudio \
	&& echo rstudio | passwd rstudio --stdin 

RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='http://cran.r-project.org', INSTALL_opts='--no-html')"

COPY supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor \
	&& chmod 777 -R /var/log/supervisor

EXPOSE 8787 3838

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

