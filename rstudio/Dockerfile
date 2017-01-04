FROM izone/hadoop:anaconda
MAINTAINER Leonardo Loures <luvres@hotmail.com>

RUN apt-get -y install \
    gdebi-core libzmq3-dev libcurl4-openssl-dev libssl-dev

# R
RUN echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran3/" >>/etc/apt/sources.list \
    && apt-key adv --keyserver keys.gnupg.net --recv-key 6212B7B7931C4BB16280BA1306F90DE5381BA480 \
    && apt-get -y update \
    && apt-get -y install r-base

# RStudio Server
ENV RSTUDIO_VERSION 1.0.44
RUN curl -s https://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb -o rstudio.deb \
    && gdebi -n rstudio.deb \
    && rm rstudio.deb
RUN R -e "install.packages(c('crayon', 'pbdZMQ', 'devtools'))" \
    && R -e "devtools::install_github(paste0('IRkernel/', c('repr', 'IRdisplay', 'IRkernel')))" \
    && R -e "IRkernel::installspec()"

RUN echo "root:root" | chpasswd \
    && echo 'auth-minimum-user-id=0' >> /etc/rstudio/rserver.conf

RUN echo "" >>/etc/supervisord.conf \
    && echo "[program:rstudio]" >>/etc/supervisord.conf \
    && echo "command=/usr/lib/rstudio-server/bin/rserver --server-daemonize=0 --server-app-armor-enabled=0" >>/etc/supervisord.conf

EXPOSE 8787
