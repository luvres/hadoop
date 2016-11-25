FROM izone/hadoop
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Miniconda3
RUN wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local/miniconda3 \
    && ln -s /usr/local/miniconda3/ /opt/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/opt/miniconda3/bin:$PATH
RUN conda install jupyter -y \
    && pip install --upgrade pip \
    && pip install mrjob

RUN  mkdir $HOME/notebooks

RUN echo "" >>/etc/supervisord.conf \
    && echo "[program:jupyter]" >>/etc/supervisord.conf \
    && echo "command=jupyter notebook --notebook-dir=$HOME/notebooks \
    --ip='*' --no-browser" >>/etc/supervisord.conf

# Jupyter Notebook ports
EXPOSE 8888

