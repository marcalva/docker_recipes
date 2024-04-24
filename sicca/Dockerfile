# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/py_r_base:1.2

LABEL version=1.0

SHELL ["/bin/bash", "-c"]

USER root

# macs2
RUN pip install macs2

# R packages
COPY r_install_pkgs.R /opt/r_install_pkgs.R

RUN Rscript /opt/r_install_pkgs.R && rm /opt/r_install_pkgs.R || exit 1

# switch back to user
USER ubuntu

# Default command for "docker run"
CMD ["/bin/bash"]
