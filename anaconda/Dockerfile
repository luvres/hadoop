FROM izone/hadoop
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Anaconda3 -> https://www.continuum.io/downloads
RUN wget -c https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh \
    && /bin/bash Anaconda3-4.2.0-Linux-x86_64.sh -b -p /usr/local/anaconda3 \
    && ln -s /usr/local/anaconda3/ /opt/anaconda3 \
    && rm Anaconda3-4.2.0-Linux-x86_64.sh
ENV PATH=/opt/anaconda3/bin:$PATH
RUN pip install --upgrade pip \
    && pip install mrjob

RUN  mkdir $HOME/notebooks

RUN echo "" >>/etc/supervisord.conf \
    && echo "[program:jupyter]" >>/etc/supervisord.conf \
    && echo "command=jupyter notebook --notebook-dir=$HOME/notebooks \
    --ip='*' --no-browser" >>/etc/supervisord.conf

# Jupyter Notebook ports
EXPOSE 8888


