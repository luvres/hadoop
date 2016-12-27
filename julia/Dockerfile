FROM izone/hadoop:rstudio
MAINTAINER Leonardo Loures <luvres@hotmail.com>

ENV JULIA_V 0.5
ENV JULIA_VERSION 0.5.0
ENV JULIA_PATH /usr/local/julia-${JULIA_VERSION}

RUN mkdir $JULIA_PATH \
    && curl https://julialang.s3.amazonaws.com/bin/linux/x64/${JULIA_V}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz | tar -xzf - -C ${JULIA_PATH} --strip-components 1 \
    && ln -s $JULIA_PATH /opt/julia

ENV JU_HOME=/opt/julia
ENV PATH $PATH:$JU_HOME/bin

RUN julia -e 'Pkg.add("Gadfly")'
