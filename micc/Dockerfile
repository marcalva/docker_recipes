# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/py_r_base:1.3

LABEL version=1.0

SHELL ["/bin/bash", "-c"]

USER root

#=======================================
# CellRanger
#=======================================

RUN wget -O cellranger-arc-2.0.2.tar.gz "https://cf.10xgenomics.com/releases/cell-arc/cellranger-arc-2.0.2.tar.gz?Expires=1714810668&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1hcmMvY2VsbHJhbmdlci1hcmMtMi4wLjIudGFyLmd6IiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzE0ODEwNjY4fX19XX0_&Signature=BnKpOUDtpofzp-wXh-PyMn1Tm9Gox2Kx8LyZ8nlF-FnrGnzLdT6pPYJvJJUhGz8rvvr5sXN6JYYK39~uwVC72yDsvQK6XKf8HH1PcoAL8xUSUwiuvZT9fMO4BIHQb~i56NZ7PM31pkx2VHp9KogDSo4cvjyeJkpOJ1YY4SmnsmffiMNRd9qX1Y3QOAbmNpJg37GN5ng7hoplSGMgpAXrdUSDETID6zR55DkDZkvTtOaMb3OOgSR0trLdFppmWJ7t4nnQwgfCYZbEgaFAXE0IqifiB9xeYkadZX3gKHT3KVb6-K9Fx1WRuid96wIBOFTD6v1m-T6Gbvc-N30zEJxDhA__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"

RUN tar -xzf cellranger-arc-2.0.2.tar.gz && \
    rm cellranger-arc-2.0.2.tar.gz && \
    mv cellranger-arc-2.0.2 /opt/ && \
    chmod 755 /opt/cellranger-arc-2.0.2

#=======================================
# R packages
#=======================================

COPY r_install_pkgs.R /opt/r_install_pkgs.R

RUN Rscript /opt/r_install_pkgs.R && rm /opt/r_install_pkgs.R || exit 1

#=======================================
# Python packages
#=======================================

COPY py_req.txt /opt/py_req.txt

RUN pip install -r /opt/py_req.txt && rm /opt/py_req.txt

#=======================================
# ambimux
#=======================================

RUN git clone --recurse-submodules https://github.com/marcalva/ambimux.git && \
    cd ambimux && \
    make hts && \
    make && \
    cp ambimux /usr/local/bin && \
    cd ../ && \
    rm -rf ambimux

#=======================================
# demuxlet
#=======================================

RUN wget https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2 && \
    tar -xjf htslib-1.10.2.tar.bz2 && \
    rm -rf htslib-1.10.2.tar.bz2 && \
    cd htslib-1.10.2 && \
    ./configure --prefix="$PWD" --with-libdeflate && \
    make && \
    cd ../ && \
    mv htslib-1.10.2 htslib

# make sure libdeflate is in lib path
# sed -i 's/#include <inttypes.h>/#define __STDC_FORMAT_MACROS\n#include <inttypes.h>/g' filter.cpp
RUN git clone https://github.com/statgen/demuxlet.git && \
    cd demuxlet && \
    autoreconf -vfi && \
    ./configure LIBS='-ldeflate' && \
    make && \
    make install && \
    cd ../ && \
    rm -rf demuxlet htslib

#=======================================
# popscle
#=======================================

# export CMAKE_LIBRARY_PATH="${mamba_prefix}/lib/"
RUN git clone https://github.com/statgen/popscle.git && \
    cd popscle && \
    sed -i 's/#include <cassert>/#include <cassert>\n#include <limits>\n#include <stddef.h>/' gtf_interval_tree.h && \
    sed -i 's/#include <regex.h>/#include <regex.h>\n#include <cinttypes>/' filter.cpp && \
    sed -i 's/#include <ctype.h>/#define __STDC_FORMAT_MACROS 1\n#include <ctype.h>/' filter.cpp && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf popscle

#=======================================
# plink
#=======================================

RUN wget https://s3.amazonaws.com/plink2-assets/plink2_linux_amd_avx2_20240418.zip && \
    unzip plink2_linux_amd_avx2_20240418.zip && \
    mv plink2 /usr/local/bin && \
    rm plink2_linux_amd_avx2_20240418.zip

# plink pgenlib
RUN git clone https://github.com/chrchang/plink-ng.git && \
    cd plink-ng/2.0/Python/ && \
    python3 setup.py build_clib build_ext -i && \
    python3 setup.py install && \
    cd ../../../ && \
    rm -rf plink-ng

#=======================================
# macs2
#=======================================

RUN pip install macs2

#=======================================
# snapatac2
#=======================================

# # switch back to user
# USER ubuntu
# 
# # requires mamba env
# ENV MAMBA_ROOT_PREFIX="/home/ubuntu/.mamba"
# RUN eval "$(micromamba shell hook --shell bash)" && \
#     micromamba create -n snapatac2 python=3.10 -y -c conda-forge && \
#     micromamba activate snapatac2 && \
#     pip install snapatac2 harmonypy xgboost
# 
#=======================================
# scenic+/pycisTopic
#=======================================

# switch back to user
USER ubuntu

# requires mamba env
ENV MAMBA_ROOT_PREFIX="/home/ubuntu/.mamba"
RUN eval "$(micromamba shell hook --shell bash)" && \
    micromamba create -n scenicplus python=3.11 -y -c conda-forge && \
    micromamba activate scenicplus && \
    git clone https://github.com/aertslab/scenicplus.git && \
    cd scenicplus && \
    pip install . && \
    cd ../ && \
    rm -rf scenicplus

# Default command for "docker run"
CMD ["/bin/bash"]
