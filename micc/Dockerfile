# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/py_r_base:1.4

LABEL version=1.3

SHELL ["/bin/bash", "-c"]

USER root

#=======================================
# CellRanger
#=======================================

RUN wget -O cellranger-arc-2.0.2.tar.gz "https://cf.10xgenomics.com/releases/cell-arc/cellranger-arc-2.0.2.tar.gz?Expires=1727885377&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=W7Y8p5AXZl~V4v3UkBa4tAYFMidqaneQjzn48j944Ez20t4PQrWysf5tIuyyp0wmjsi9-Y3hM~ps-ucWb23v0OXXc2ayObMZwe9KA1-Yyx4xflIcMRAR4sqxj8x-h6s7xWLTPIM9Bt9TwG9CytMd3NrSOWGgCREExjlTMZm2sR44R~0CevX5bHhElPV2Sqi-ZjD0D3K0dY83f0i-SsAlmOlQedoDaIKL~FrKVK19kbUu2JajFOqKpqF3hfmGG-ItcXBUl8MOq031wSp1PJVYVrJpYJgydqznepYb9hsKH3EJ3Ht40n-Pa73aNXH16b~j~zcZ2~QI~1WP3My5vALWMg__"

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
# bedtools
#=======================================

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.31.1/bedtools-2.31.1.tar.gz && \
    tar -xzf bedtools-2.31.1.tar.gz && \
    rm bedtools-2.31.1.tar.gz && \
    cd bedtools2 && \
    make && \
    mv bin/* /usr/local/bin/ && \
    cd ../ && \
    rm -rf bedtools2

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

RUN wget https://s3.amazonaws.com/plink2-assets/alpha5/plink2_linux_amd_avx2_20240526.zip && \
    unzip plink2_linux_amd_avx2_20240526.zip && \
    mv plink2 /usr/local/bin && \
    rm plink2_linux_amd_avx2_20240526.zip

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
