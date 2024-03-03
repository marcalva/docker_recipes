# syntax=docker/dockerfile:1
FROM nvcr.io/nvidia/pytorch:24.02-py3

LABEL version=1.0

ENV SHELL /bin/bash
ENV TERM xterm-256color

ENV HOME /root
WORKDIR $HOME

COPY bash.bashrc ${HOME}/.bashrc

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

ENV LANG="C.UTF-8" \
    TZ="PST" \
    DEBIAN_FRONTEND=noninteractive

# basic packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    gcc \
    clangd \
    man-db \
    manpages \
    git \
    git-lfs \
    bzip2 \
    zip \
    unzip \
    curl \
    wget \
    gettext \
    shellcheck \
    zip \
    unzip \
    bat \
    ripgrep \
    fd-find && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3-venv \
    python3-distutils \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# neovim
RUN apt-get update && apt-get install -y \
    cmake \
    ninja-build && \
    rm -rf /var/lib/apt/lists/* && \
    wget "https://github.com/neovim/neovim/archive/refs/tags/nightly.tar.gz" && \
    tar -xzf nightly.tar.gz && \
    rm nightly.tar.gz && \
    cd ./neovim-nightly && \
    make CMAKE_BUILD_TYPE=Release && \
    make install && \
    cd ../ && \
    rm -rf neovim-nightly && \
    mkdir -p .config/ && cd .config/ && \
    git clone  https://github.com/marcalva/nvim_config.git nvim && \
    cd ../ && \
    nvim -c 'Lazy install' -c 'sleep 20' -c qa --headless && \
    apt-get purge -y --auto-remove \
    cmake \
    ninja-build && \
    apt autoclean -y

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

# shellharden
RUN apt-get update && apt-get install -y \
    rustc \
    cargo && \
    rm -rf /var/lib/apt/lists/* && \
    cargo install shellharden && \
    apt-get purge -y --auto-remove \
    rustc \
    cargo && \
    apt autoclean -y

# bash-lsp, node
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    npm i -g bash-language-server

RUN pip install pyright flake8

# Default command for "docker run"
CMD ["/bin/bash"]
