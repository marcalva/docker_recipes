# syntax=docker/dockerfile:1
FROM nvcr.io/nvidia/pytorch:24.02-py3

LABEL version=1.1

ENV SHELL /bin/bash
ENV TERM xterm-256color

ENV HOME /root
WORKDIR $HOME

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
    tree \
    bat \
    ripgrep \
    rustc \
    cargo \
    cmake \
    ninja-build \
    fd-find && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
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
RUN wget "https://github.com/neovim/neovim/archive/refs/tags/nightly.tar.gz" && \
    tar -xzf nightly.tar.gz && \
    rm nightly.tar.gz && \
    cd ./neovim-nightly && \
    make CMAKE_BUILD_TYPE=Release && \
    make install && \
    cd ../ && \
    rm -rf neovim-nightly

# non-root user
RUN apt-get update -y && \
    apt-get install -y sudo && \
    addgroup --gid 1000 ubuntu && \
    adduser --shell /bin/bash --uid 1000 --gid 1000 --disabled-password --gecos "" ubuntu && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/ubuntu
WORKDIR $HOME
COPY bash.bashrc ${HOME}/.bashrc
RUN chown ubuntu:ubuntu ${HOME}/.bashrc

USER ubuntu

RUN mkdir -p .config/ && cd .config/ && \
    git clone  https://github.com/marcalva/nvim_config.git nvim && \
    cd ../ && \
    nvim -c 'Lazy install' -c 'sleep 20' -c qa --headless

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
RUN cargo install shellharden && \
    echo "PATH=$PATH:/home/ubuntu/.cargo/bin/" >> .bashrc

# bash-lsp, node
RUN sudo npm i -g bash-language-server

RUN sudo pip install pyright flake8

# mamba
USER root
ENV MAMBA_ROOT_PREFIX="/opt/conda"
ENV MAMBA_EXE="/usr/local/bin/micromamba"
COPY _mamba_sh.sh /usr/local/bin/_mamba_sh.sh
RUN curl -Ls curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | \
    tar -xvj bin/micromamba && \
    mv bin/micromamba ${MAMBA_EXE} && \
    rm -rf bin && \
    mkdir -p "$MAMBA_ROOT_PREFIX" && \
    echo "source /usr/local/bin/_mamba_sh.sh" >> ~/.bashrc && \
    pip install conda-lock

COPY _entry.sh /usr/local/bin/_entry.sh
ENTRYPOINT ["/usr/local/bin/_entry.sh"]

USER root
RUN apt-get purge -y --auto-remove \
    rustc \
    cmake \
    ninja-build \
    cargo && \
    apt autoclean -y

USER ubuntu

# Default command for "docker run"
CMD ["/bin/bash"]
