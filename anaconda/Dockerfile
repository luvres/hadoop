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

RUN echo "" >>/etc/supervisord.conf \
    && echo "[program:pyspark]" >>/etc/supervisord.conf \
    && echo "command=pyspark" >>/etc/supervisord.conf

# Spark -> http://spark.apache.org/downloads.html
RUN wget -c http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz \
    && tar -xzf spark-2.0.2-bin-hadoop2.7.tgz \
    && mv spark-2.0.2-bin-hadoop2.7 /usr/local/ \
    && ln -s /usr/local/spark-2.0.2-bin-hadoop2.7/ /opt/spark

ENV NOTEBOOKS_PATH=/root/notebooks
RUN mkdir $NOTEBOOKS_PATH

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=ipython
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip='*' --no-browser --notebook-dir=$NOTEBOOKS_PATH"

VOLUME $NOTEBOOKS_PATH

# Jupyter Notebook ports
EXPOSE 8888

# Spark management ports
EXPOSE 4040

