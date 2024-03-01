# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/ubuntu_base:1.1

LABEL version=1.0

SHELL ["/bin/bash", "-c"]

VOLUME /workspace

WORKDIR "$HOME"

COPY conda-lock.yml /opt/conda/pytorch_conda-lock.yml

COPY _entry.sh /usr/local/bin/_entry.sh

ENTRYPOINT ["/usr/local/bin/_entry.sh"]

# Default command for "docker run"
CMD "/bin/bash"
