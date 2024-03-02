# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/ubuntu_base:1.1

LABEL version=1.1

SHELL ["/bin/bash", "-c"]

VOLUME /workspace

WORKDIR "$HOME"

COPY conda-lock.yml /opt/conda/pytorch_conda-lock.yml

RUN micromamba create -y -n pytorch -f /opt/conda/pytorch_conda-lock.yml && \
    micromamba clean -afy && \
    micromamba clean --index-cache

RUN source /usr/local/bin/_mamba_sh.sh && \
    micromamba activate pytorch && \
    pip install \
    flash-attn \
    ray \
    cellxgene-census \
    tiledbsoma \
    --no-build-isolation


COPY _entry.sh /usr/local/bin/_entry.sh

ENTRYPOINT ["/usr/local/bin/_entry.sh"]

# Default command for "docker run"
CMD "/bin/bash"
