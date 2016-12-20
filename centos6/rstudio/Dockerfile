FROM izone/hadoop:cos6-anaconda
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN yum install -y R

# rJava
RUN curl -L http://cran.r-project.org/src/contrib/rJava_0.9-8.tar.gz -o rJava_0.9-8.tar.gz
RUN R CMD INSTALL rJava_0.9-8.tar.gz
RUN R CMD javareconf \
	&& rm -rf rJava_0.9-8.tar.gz

# RStudio
ENV RSTUDIO_VERSION 1.0.44
RUN yum install -y --nogpgcheck \
    https://download2.rstudio.org/rstudio-server-rhel-${RSTUDIO_VERSION}-x86_64.rpm
ENV PATH /usr/lib/rstudio-server/bin/:$PATH 

RUN groupadd rstudio \
	&& useradd -g rstudio rstudio \
	&& echo rstudio | passwd rstudio --stdin 

RUN echo "root:root" | chpasswd \
    && echo 'auth-minimum-user-id=0' >>/etc/rstudio/rserver.conf

RUN echo "" >>/etc/supervisord.conf \
    && echo "[program:rserver]" >>/etc/supervisord.conf \
    && echo "command=/usr/lib/rstudio-server/bin/rserver" >>/etc/supervisord.conf

EXPOSE 8787

