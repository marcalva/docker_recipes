# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/py_r_base:1.3

LABEL version=1.0

SHELL ["/bin/bash", "-c"]

USER root

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
# CellRanger
#=======================================

RUN wget -O cellranger-arc-2.0.2.tar.gz "https://cf.10xgenomics.com/releases/cell-arc/cellranger-arc-2.0.2.tar.gz?Expires=1714630581&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1hcmMvY2VsbHJhbmdlci1hcmMtMi4wLjIudGFyLmd6IiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzE0NjMwNTgxfX19XX0_&Signature=dHcB3utpGPyfpjHzGjkv3pcHTzArI1Mmts5F3Oxu3Uupm5hU4O1NXgYwonNfcxwOZhJdGSFDzHZTeBw3SiuINutznQnezjixhkcs--XIU0ENcjJ63ZKTBzJ6qCFZ8~M7s7OTz30IL5FwxCqyjOhr-ONkEBiYSVrysOb75Ob2TPPEHZlERMqgL0RIkzE64DpA2EsVvg~TZB4Lq~ZaBFvYMV80bN8Q5VAJP-tvOSJ-FVBW62mOHrAcI2Mcr9WqieI4UuByjwvp6rvxt7Fh3w4wxLSCBu4dVjlscP3dbsHMUdUnvtq7z3q-LhshYj1gVn6p5YWG4nTOToUv~tNZGZY~yA__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"

RUN tar -xzf cellranger-arc-2.0.2.tar.gz && \
    rm cellranger-arc-2.0.2.tar.gz && \
    mv cellranger-arc-2.0.2 /opt/ && \
    chmod 755 /opt/cellranger-arc-2.0.2

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

# switch back to user
USER ubuntu

# Default command for "docker run"
CMD ["/bin/bash"]
