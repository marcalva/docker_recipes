# Build a docker file Ubuntu base image
# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV TERM xterm-256color

RUN yes| unminimize

ENV HOME /root
WORKDIR $HOME

COPY bash.bashrc ${HOME}/.bashrc

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    TZ="PST" \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y \
    software-properties-common systemd \
    build-essential \
    autoconf automake libtool autotools-dev libtool-bin \
    cmake \
    clangd \
    gdb \
    dpkg-repack \
    man-db manpages \
    nfs-common

RUN apt-get install -y \
    git git-lfs \
    zlib1g zlib1g-dev libssl-dev \
    bzip2 liblzma-dev liblzma5 \
    libdeflate-tools libdeflate-dev libdeflate0 \
    libffi-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libfreetype-dev \
    libtiff-dev libjpeg-dev libpng-dev \
    libfontconfig1-dev \
    libxml2-dev \
    libcurl4-gnutls-dev curl wget \
    ncurses-base libncurses-dev \
    gettext \
    libfuse3-3 libfuse3-dev fuse \
    xauth \
    shellcheck \
    zip unzip \
    python3-pip \
    vim

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | \
    tar -xvj bin/micromamba && \
    mv ${HOME}/bin/micromamba /usr/local/bin/ && \
    rm -rf ${HOME}/bin && \
    pip install conda-lock && \
    micromamba shell init --shell bash --root-prefix=~/micromamba

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt install -y nodejs

RUN npm i -g bash-language-server

# fzf
RUN cd $HOME && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    .fzf/install \
        --all \
        --key-bindings \
        --completion \
        --update-rc \
        --no-zsh \
        --no-fish

# rust
RUN cd $HOME && \
    echo "$HOME" && \
    cat /etc/bash.bashrc && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rust_i.sh && \
    chmod u+x rust_i.sh && \
    ./rust_i.sh -y && \
    rm rust_i.sh

# bat, ripgrep, fd-find
RUN cd $HOME && \
    . "$HOME/.cargo/env" && \
    echo $PATH && \
    cargo install --locked bat && \
    cargo install ripgrep && \
    cargo install fd-find && \
    cargo install shellharden

# neovim
RUN wget "https://github.com/neovim/neovim/archive/refs/tags/nightly.tar.gz" && \
    tar -xzf nightly.tar.gz && \
    rm nightly.tar.gz && \
    cd ./neovim-nightly && \
    make CMAKE_BUILD_TYPE=Release && \
    make install && \
    cd ../ && \
    rm -rf neovim-nightly

RUN mkdir -p .config/ && cd .config/ && \
    git clone  https://github.com/marcalva/nvim_config.git nvim && \
    cd ../ && \
    nvim -c 'Lazy install' -c 'sleep 20' -c qa --headless

VOLUME /workspace
WORKDIR /workspace

