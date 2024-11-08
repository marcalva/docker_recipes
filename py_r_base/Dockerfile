# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/ubuntu_base:1.3

LABEL version=1.4

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
    libcurl4-openssl-dev \
    libxml2-dev \
    libgsl27 \
    libgsl-dev \
    libcairo2 \
    libcairo2-dev \
    libmagick++-dev \
    gettext && \
    rm -rf /var/lib/apt/lists/*

# R
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | \
    tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

RUN apt-get purge -y r-base* r-recommended r-cran-*

RUN apt-get update -y && apt-get install -y \
    r-base r-base-core r-recommended r-base-dev && \
    rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'update.packages(ask = FALSE, checkBuilt = TRUE)'

COPY r_install_pkgs.R /opt/r_install_pkgs.R

RUN Rscript /opt/r_install_pkgs.R && rm /opt/r_install_pkgs.R || exit 1

# Python
RUN apt-get update -y && apt-get install -y \
    python3-pip \
    python3-distutils \
    python3-venv && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip && \
    pip install --upgrade setuptools

RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update -y

COPY py_req.txt /opt/py_req.txt

RUN pip install -r /opt/py_req.txt && rm /opt/py_req.txt

RUN echo "building claude"
RUN --mount=type=secret,id=github_token \
    export GH_TOKEN=$(cat /run/secrets/github_token) && \
    pip install --no-cache-dir git+https://${GH_TOKEN}@github.com/marcalva/claude-chat.git && \
    claude-chat --initialize && \
    echo "Successfully installed claude packages"; \
    unset GH_TOKEN

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

USER ubuntu

RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc

# Default command for "docker run"
CMD ["/bin/bash"]
