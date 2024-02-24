# Docker recipes

## nvidia_dev

A docker image built on `nvcr.io/nvidia/pytorch:24.01-py3`.

This recipe builds a docker image with my preferred setup, including
- development and build tools, such as make and git,
- neovim and my config,
- python 3.10 with modules such as numpy and scikit (no torch),
- R (latest) and tidyverse packages,
- bat, ripgrep, fd-find, and fzf,
- mamba.

To build the docker image
```bash
git clone https://github.com/marcalva/docker_recipes.git
cd nvidia_dev
docker build -t nvidia_dev:1.0 .
```