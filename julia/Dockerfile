FROM izone/hadoop:rstudio
MAINTAINER Leonardo Loures <luvres@hotmail.com>

ENV JULIA_V 0.7
ENV JULIA_VERSION 0.7.0
ENV JULIA_PATH /usr/local/julia-${JULIA_VERSION}

RUN mkdir $JULIA_PATH \
    && curl https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_V}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz | tar -xzf - -C ${JULIA_PATH} --strip-components 1 \
    && ln -s $JULIA_PATH /opt/julia \
    && sed -i 's/# end aliases/alias j="julia"\n# end aliases/' $HOME/.bashrc

ENV JU_HOME=/opt/julia
ENV PATH $PATH:$JU_HOME/bin

RUN julia -e 'Pkg.add("IJulia")' \
    && julia -e 'Pkg.add("Gadfly")'
