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
RUN echo "" >>/etc/supervisord.conf \
    && echo "[program:pyspark]" >>/etc/supervisord.conf \
    && echo "command=pyspark" >>/etc/supervisord.conf

# jdbc
RUN mkdir /usr/local/jdbc \
    && wget -c https://github.com/luvres/jdbc/raw/master/mysql-connector-java-5.1.40-bin.jar -O /usr/local/jdbc/mysql-connector-java-5.1.40-bin.jar \
    && wget -c https://github.com/luvres/jdbc/raw/master/mariadb-java-client-1.4.6.jar -O /usr/local/jdbc/mariadb-java-client-1.4.6.jar \
    && wget -c https://github.com/luvres/jdbc/raw/master/ojdbc7.jar -O /usr/local/jdbc/ojdbc7.jar \
    && wget -c https://github.com/luvres/jdbc/raw/master/postgresql-9.4.1212.jar -O /usr/local/jdbc/postgresql-9.4.1212.jar

# Spark
ENV SPARK_VERSION 2.0.2
RUN wget -c http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && tar -xzf spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && rm spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop2.7 /usr/local/ \
    && ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.7/ /opt/spark
RUN ln -s /usr/local/jdbc/mysql-connector-java-5.1.40-bin.jar /opt/spark/jars/mysql-connector.jar \
    && ln -s /usr/local/jdbc/mariadb-java-client-1.4.6.jar /opt/spark/jars/mariadb-connector.jar \
    && ln -s /usr/local/jdbc/ojdbc7.jar /opt/spark/jars/ojdbc7.jar \
    && ln -s /usr/local/jdbc/postgresql-9.4.1212.jar /opt/spark/jars/postgresql-connector.jar
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin
ENV NOTEBOOKS_PATH=/root/notebooks
RUN mkdir $NOTEBOOKS_PATH
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=ipython
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip='*' --no-browser --notebook-dir=$NOTEBOOKS_PATH"

# Bash colors
ENV RESET='\[$(tput sgr0)\]'
ENV GREY='\[$(tput setaf 0)\]'
ENV RED='\[$(tput setaf 1)\]'
ENV GREEN='\[$(tput setaf 2)\]'
ENV YELLOW='\[$(tput setaf 3)\]'
ENV BLUE='\[$(tput setaf 4)\]'
ENV PURPLE='\[$(tput setaf 5)\]'
ENV CYAN='\[$(tput setaf 6)\]'
ENV WHITE='\[$(tput setaf 7)\]'
RUN echo 'export PS1="[${WHITE}\u${BLUE}@${WHITE}\h${WHITE}\w${RESET}]# "' >>$HOME/.bashrc

VOLUME $NOTEBOOKS_PATH

# Jupyter Notebook ports
EXPOSE 8888

# Spark management ports
EXPOSE 4040

