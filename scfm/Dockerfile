# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/py_r_nvidia:1.0

LABEL version=1.4

SHELL ["/bin/bash", "-c"]

USER root

# required development libraries
RUN apt-get update -y && apt-get install -y \
    less && \
    rm -rf /var/lib/apt/lists/*

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

#=======================================
# Python packages
#=======================================

COPY py_req.txt /opt/py_req.txt
RUN pip install -r /opt/py_req.txt && rm /opt/py_req.txt

#=======================================
# UCSC bin utils
#=======================================

RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bigBedToBed && \
    mv bigBedToBed /usr/local/bin && \
    chmod a+x /usr/local/bin/bigBedToBed

ENV MAMBA_ROOT_PREFIX="/home/ubuntu/.mamba"

# switch back to user
USER ubuntu

RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc

# Default command for "docker run"
CMD ["/bin/bash"]
