FROM izone/hadoop
MAINTAINER Leonardo Loures <luvres@hotmail.com>

# Anaconda3
ENV PATH=/opt/anaconda3/bin:$PATH
RUN \
	ANACONDA_VERSION=5.2.0 \
    && curl -L https://repo.continuum.io/archive/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -o Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh \
    && /bin/bash Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -b -p /usr/local/anaconda3 \
    && ln -s /usr/local/anaconda3/ /opt/anaconda3 \
    && rm Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh \
  \
    && apt-get install --no-install-recommends -y \
                git g++ \
                texlive \
                texlive-xetex \
                texlive-generic-recommended \
  \
	&& pip install --upgrade pip \
    && pip install \
                mrjob \
                shapely \
                selenium \
                termcolor \
                scrapy \
                js2xml \
                celery \
              \
                msgpack \
                git+https://github.com/pydata/pandas-datareader.git \
                ggplot \
              \
                tensorflow \
  \
  # jdbc
	&& mkdir /usr/local/jdbc \
    && curl -L https://github.com/luvres/jdbc/raw/master/mysql-connector-java-5.1.47-bin.jar -o /usr/local/jdbc/mysql-connector-java-5.1.47-bin.jar \
    && curl -L https://github.com/luvres/jdbc/raw/master/mariadb-java-client-2.2.6.jar -o /usr/local/jdbc/mariadb-java-client-2.2.6.jar \
    && curl -L https://github.com/luvres/jdbc/raw/master/ojdbc7.jar -o /usr/local/jdbc/ojdbc7.jar \
    && curl -L https://github.com/luvres/jdbc/raw/master/ojdbc6.jar -o /usr/local/jdbc/ojdbc6.jar \
    && curl -L https://github.com/luvres/jdbc/raw/master/postgresql-42.2.5.jar -o /usr/local/jdbc/postgresql-42.2.5.jar \
  \
  # Spark
	&& SPARK_VERSION=2.3.2 \
	&& curl http://mirror.nbtelecom.com.br/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz | tar -xzf - -C /usr/local/ \
#	&& curl http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz | tar -xzf - -C /usr/local/ 
    && ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.7/ /opt/spark \
	&& ln -s /usr/local/jdbc/mysql-connector-java-5.1.47-bin.jar /opt/spark/jars/mysql-connector.jar \
    && ln -s /usr/local/jdbc/mariadb-java-client-2.2.6.jar /opt/spark/jars/mariadb-connector.jar \
    && ln -s /usr/local/jdbc/ojdbc7.jar /opt/spark/jars/ojdbc7.jar \
    && ln -s /usr/local/jdbc/ojdbc6.jar /opt/spark/jars/ojdbc6.jar \
    && ln -s /usr/local/jdbc/postgresql-42.2.5.jar /opt/spark/jars/postgresql-connector.jar

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV NOTEBOOKS_PATH=/root/notebooks
RUN mkdir $NOTEBOOKS_PATH
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=ipython
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --allow-root --ip='*' \
										 --no-browser \
										 --notebook-dir=$NOTEBOOKS_PATH \
										 --NotebookApp.token=''"

RUN echo "" >>/etc/supervisord.conf \
    && echo "[program:pyspark]" >>/etc/supervisord.conf \
    && echo "command=pyspark" >>/etc/supervisord.conf

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
RUN sed -i '/export/s/# //' $HOME/.bashrc \
    && sed -i 's/# alias/alias/' $HOME/.bashrc \
    && echo 'alias h="history"' >>$HOME/.bashrc \
    && echo '# end aliases' >>$HOME/.bashrc \
    && echo "" >>$HOME/.bashrc \
    && echo 'export PS1="[${WHITE}\u${RED}@${WHITE}\h${WHITE}:\w${RESET}]# "' >>$HOME/.bashrc

VOLUME $NOTEBOOKS_PATH

# Jupyter Notebook ports
EXPOSE 8888

# Spark management ports
EXPOSE 4040 8080
