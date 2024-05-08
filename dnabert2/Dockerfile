# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ghcr.io/marcalva/nvidia_pytorch:1.1

LABEL version=1.0

SHELL ["/bin/bash", "-c"]

USER root

RUN pip install \
    einops \
    "transformers==4.29.2" \
    peft \
    omegaconf \
    evaluate \
    accelerate

# triton needs to be removed, the required version
# "triton==2.0.0.dev20221103" has a ton of conflicts with current pytorch.
RUN pip uninstall -y triton

USER ubuntu

# Default command for "docker run"
CMD ["/bin/bash"]
