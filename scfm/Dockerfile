# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/nvidia_pytorch:1.2

LABEL version=1.2

SHELL ["/bin/bash", "-c"]

USER root

# required development libraries
RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    dirmngr \
    libfreetype-dev \
    libffi-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libtiff-dev \
    libjpeg-dev \
    libpng-dev \
    libfontconfig1-dev \
    zlib1g \
    zlib1g-dev \
    liblzma-dev \
    liblzma5 \
    libssl-dev \
    ncurses-base \
    libncurses-dev \
    gettext && \
    rm -rf /var/lib/apt/lists/*

# build tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    autoconf automake libtool autotools-dev libtool-bin \
    cmake clangd gdb && \
    rm -rf /var/lib/apt/lists/*

# htslib
RUN git clone https://github.com/samtools/htslib && \
    cd htslib && \
    git submodule update --init --recursive && \
    autoreconf -i && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -rf htslib

# samtools
RUN git clone https://github.com/samtools/samtools && \
    cd samtools && \
    autoreconf && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -rf samtools

# bcftools
RUN git clone https://github.com/samtools/bcftools && \
    cd bcftools && \
    autoreconf && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -rf bcftools

#=======================================
# bedtools
#=======================================

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.31.1/bedtools-2.31.1.tar.gz && \
    tar -xzf bedtools-2.31.1.tar.gz && \
    cd bedtools2 && \
    make && \
    mv bin/* /usr/local/bin/ && \
    cd ../ && \
    rm -rf bedtools2 bedtools-2.31.1.tar.gz

# Python
RUN apt-get update -y && apt-get install -y \
    python3-pip \
    python3-distutils \
    python3-venv && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update -y

COPY py_req.txt /opt/py_req.txt

RUN pip install -r /opt/py_req.txt && rm /opt/py_req.txt

ENV MAMBA_ROOT_PREFIX="/home/ubuntu/.mamba"

#=======================================
# UCSC bin utils
#=======================================

RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bigBedToBed && \
    mv bigBedToBed /usr/local/bin && \
    chmod a+x /usr/local/bin/bigBedToBed

# switch back to user
USER ubuntu

RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc

# Default command for "docker run"
CMD ["/bin/bash"]
