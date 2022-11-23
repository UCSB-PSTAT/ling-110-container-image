FROM ucsb/jupyter-base:latest

MAINTAINER LSIT Systems <lsitops@lsit.ucsb.edu>

USER root

RUN apt update && \
    apt install -y \
        git \
        wget \
        tcsh \
        gawk \
        tar \
        make && \
    apt-get clean

#-- Install SRILM
RUN mkdir /usr/bin/srilm
WORKDIR /usr/bin/srilm
RUN wget https://sjtodd.github.io/ling110/srilm-1.7.3.tar.gz && \
    tar xvf srilm-1.7.3.tar.gz && \
    sed -i '1i SRILM = /usr/bin/srilm' Makefile && \
    make MAKE_PIC=yes World && \
    make cleanest 

RUN pip install gensim \
    scikit-learn \
    pytest \
    PTable \
    nltk \
    arpa \
    morfessor

USER $NB_USER

# Set environment variables for SRILM
ENV LC_NUMERIC=C \
    PATH=$PATH:/usr/bin/srilm/bin:/usr/bin/srilm/i686-m64
