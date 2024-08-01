# syntax=docker/dockerfile:1
FROM nvcr.io/nvidia/pytorch:24.02-py3

LABEL version=1.2

ENV SHELL=/bin/bash
ENV TERM=xterm-256color

ENV HOME=/root
WORKDIR $HOME

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

ENV LANG="C.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive

# basic packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    tzdata \
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
    ripgrep \
    rustc \
    cargo \
    ninja-build \
    fd-find && \
    rm -rf /var/lib/apt/lists/*

# set time
ENV TZ=US/Pacific
RUN rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# python
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

# tree-sitter for nvim latex
RUN wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.22.6/tree-sitter-linux-x86.gz && \
    gunzip tree-sitter-linux-x86.gz && \
    chmod a+x tree-sitter-linux-x86 && \
    mv tree-sitter-linux-x86 /usr/local/bin/tree-sitter

# fzf
RUN cd $HOME && \
    wget https://github.com/junegunn/fzf/releases/download/v0.54.2/fzf-0.54.2-linux_amd64.tar.gz && \
    tar -zxf fzf-0.54.2-linux_amd64.tar.gz && \
    rm fzf-0.54.2-linux_amd64.tar.gz && \
    mv fzf /usr/local/bin/

# bash-lsp, node
RUN npm i -g bash-language-server

RUN pip install basedpyright flake8 black neovim

# neovim
RUN wget https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm nvim-linux64.tar.gz && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

# RUN wget "https://github.com/neovim/neovim/archive/refs/tags/nightly.tar.gz" && \
#     tar -xzf nightly.tar.gz && \
#     rm nightly.tar.gz && \
#     cd ./neovim-nightly && \
#     make CMAKE_BUILD_TYPE=Release && \
#     make install && \
#     cd ../ && \
#     rm -rf neovim-nightly

# shellharden
RUN cargo install shellharden && \
    mv ~/.cargo/bin/shellharden /usr/local/bin/

# bat
RUN cargo install --locked bat && \
    mv ~/.cargo/bin/bat /usr/local/bin/

# non-root user
RUN apt-get update -y && \
    apt-get install -y sudo && \
    addgroup --gid 1000 ubuntu && \
    adduser --shell /bin/bash --uid 1000 --gid 1000 --disabled-password --gecos "" ubuntu && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME=/home/ubuntu
WORKDIR $HOME
COPY bash.bashrc ${HOME}/.bashrc
RUN chown ubuntu:ubuntu ${HOME}/.bashrc

USER ubuntu

RUN mkdir -p .config/ && cd .config/ && \
    git clone  https://github.com/marcalva/nvim_config.git nvim && \
    cd ../ && \
    nvim -c 'Lazy install' -c 'sleep 20' -c qa --headless

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

RUN apt-get purge -y --auto-remove \
    rustc \
    ninja-build \
    cargo && \
    apt autoclean -y

USER ubuntu

# Default command for "docker run"
CMD ["/bin/bash"]
