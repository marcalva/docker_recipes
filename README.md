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
echo "$CR_PAT" | sudo docker login ghcr.io -u marcalva --password-stdin
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

## `ubuntu_base`

This repo stores a minimal development environment with nvim and LSPs
in `ghcr.io/marcalva/ubuntu_base`.

## `pytorch`

To generate the lock file for the mamba environment, run
```bash
conda-lock -f environment.yml -p linux-64
```

## `nvidia_pytorch`

Use this image to run pytorch on NVIDIA GPUs. It has both CUDA and
pytorch properly installed and optimized.

Don't install another version of `pytorch` in the container as you want to use
the optimized version provided by NVIDIA. If you are setting up a python
virtual environment, include `--system-site-packages torch`

To run the image, use
```bash
sudo docker run --rm --gpus=all --ipc=host -it \
    -v /home/ubuntu/:/home/ubuntu/ 5154aff3a520 /bin/bash
```

### Base Image
- `FROM nvcr.io/nvidia/pytorch:24.02-py3`: Uses the NVIDIA PyTorch image as the base.
  This is built on top of the `nvcr.io/nvidia/pytorch:24.01-py3` NVIDIA
  container. See [here](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-24-01.html)
  for details on what is included in the container.
  You need to run this image on an AMI that has the NVIDIA CUDA
  drivers installed, specifically with a version `>=545`. Otherwise, the GPUs
  won't be available.

### Environment Variables
- `ENV SHELL /bin/bash`: Sets the default shell to Bash.
- `ENV TERM xterm-256color`: Sets the terminal type to xterm-256color.
- `ENV HOME /root`: Sets the home directory to `/root`.
- `ENV LANG="C.UTF-8"`: Sets the language environment variable to C.UTF-8.
- `ENV TZ="PST"`: Sets the timezone to PST.
- `ENV DEBIAN_FRONTEND=noninteractive`: Sets the Debian frontend to noninteractive mode.

### Package Installation
- Installs basic packages including `gcc`, `clangd`, `git`, `curl`, `wget`, `zip`, `unzip`, `bat`, `ripgrep`, `rustc`, `cargo`, `cmake`, `ninja-build`, and `fd-find`.
- Installs Node.js version 20.x using the official Node.js repository.
- Installs Python packages including `python3-venv`, `python3-distutils`, and `python3-pip`.

### Additional Tools
- Installs AWS CLI using the official installation script.
- Installs Neovim from the nightly release.

### Non-Root User Setup
- Creates a non-root user named `ubuntu` with UID and GID 1000.
- Copies the `bash.bashrc` file to the user's home directory.
- Sets the working directory to the user's home directory.
- Switches to the `ubuntu` user.

### User-Specific Configurations
- Clones the `nvim_config` repository and sets up Neovim configuration.
- Installs `fzf` (fuzzy finder) and configures it.
- Installs `shellharden` using Cargo.
- Installs `bash-language-server` using npm.
- Installs `pyright` and `flake8` using pip.

### Mamba Setup
- Sets up Mamba (a fast conda alternative) and configures the environment.
- Copies the `_mamba_sh.sh` script to `/usr/local/bin/`.
- Installs `conda-lock` using pip.

### Entry Point and Default Command
- Copies the `_entry.sh` script to `/usr/local/bin/` and sets it as the entry point.
- Sets the default command to `/bin/bash` when running the container.

### Cleanup
- Switches back to the `root` user.
- Removes unnecessary packages (`rustc`, `cmake`, `ninja-build`, `cargo`) to reduce the image size.
- Switches back to the `ubuntu` user.

