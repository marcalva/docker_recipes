# Docker recipes

## Building Docker containers

Since I push these to github `ghcr`, I create the containers with
a `ghcr.io/marcalva/` prefix.
```bash
docker build -t ghcr.io/marcalva/IMAGE_NAME:TAG .
```

## Pushing and pulling Docker containers

I push images to my github package repository using `docker push`. The `CR_PAT`
is the classic personal access token with package read/write access. In the
`docker push` command, the `IMAGE_NAME` is the name of the image, such as
`nvidia_dev`, and the `TAG` is the version, such as `1.0`.

```bash
export CR_PAT=YOUR_TOKEN
echo "$CR_PAT" | docker login ghcr.io -u marcalva --password-stdin
docker push ghcr.io/marcalva/IMAGE_NAME:TAG
```

To pull images for use, I use
```bash
export CR_PAT=YOUR_TOKEN
echo "$CR_PAT" | docker login ghcr.io -u marcalva --password-stdin
docker pull ghcr.io/marcalva/IMAGE_NAME:TAG
```

For pushing, you need to login with `docker login`. For pulling,
you may need to login as well.

## nvidia_dev

Use this image to run pytorch on NVIDIA GPUs. It has both CUDA and
pytorch properly installed and optimized.

This is built on top of the `nvcr.io/nvidia/pytorch:24.01-py3` NVIDIA
container. See [here](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-24-01.html)
for details on what is included in the container.
You need to run this image on an AMI that has the NVIDIA CUDA
drivers installed, specifically with a version `>=545`. Otherwise, the GPUs
won't be available.

This recipe builds a docker image with my preferred setup, including
- development and build tools, such as make and git,
- neovim and my config,
- basic python 3.10 modules such as numpy and scikit (no torch),
- R (latest) and tidyverse packages,
- bat, ripgrep, fd-find, and fzf,
- mamba.

Don't install another version of `pytorch`, as you want to use the optimized
version provided by NVIDIA. If you are setting up a python virtual
environment, include `--system-site-packages torch`

To run the image, use
```bash
docker run --privileged --rm --gpus=all --ipc=host -it \
    -v /home/ubuntu/:/home/ubuntu/ 5154aff3a520 /bin/bash
```
The docker image ID might be different. You need to 
