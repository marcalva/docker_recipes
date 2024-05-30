# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/py_r_base:1.3

LABEL version=1.0

SHELL ["/bin/bash", "-c"]

USER root

#=======================================
# python-cffi
#=======================================

RUN apt-get update -y && \
    apt-get install -y python3-cffi && \
    rm -rf /var/lib/apt/lists/*

#=======================================
# Python packages
#=======================================

RUN pip install tensorqtl Cython rpy2

#=======================================
# Python packages
#=======================================

#=======================================
# plink
#=======================================

RUN wget https://s3.amazonaws.com/plink2-assets/alpha5/plink2_linux_amd_avx2_20240105.zip && \
    unzip plink2_linux_amd_avx2_20240105.zip && \
    mv plink2 /usr/local/bin && \
    rm plink2_linux_amd_avx2_20240105.zip

# plink pgenlib
RUN git clone https://github.com/chrchang/plink-ng.git && \
    cd plink-ng/2.0/Python/ && \
    python3 setup.py build_clib build_ext -i && \
    python3 setup.py install

# switch back to user
USER ubuntu

# Default command for "docker run"
CMD ["/bin/bash"]
