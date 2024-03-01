# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/ubuntu_base:1.1

LABEL version=1.0

SHELL ["/bin/bash", "-c"]

COPY conda-lock.yml ${HOME}/
ENV MAMBA_ROOT_PREFIX ${HOME}/micromamba
RUN . ${HOME}/micromamba/etc/profile.d/micromamba.sh && \
    echo $PATH && \
    echo $MAMBA_ROOT_PREFIX && \
    micromamba create -y -n pytorch -f conda-lock.yml && \
    micromamba clean -afy && \
    micromamba clean --index-cache

VOLUME /workspace
WORKDIR /workspace

