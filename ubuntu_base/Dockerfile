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

RUN apt-get install -y libcurl4-gnutls-dev libxml2-dev \
    git git-lfs libffi-dev zlib1g zlib1g-dev libssl-dev \
    libdeflate-tools libdeflate-dev libdeflate0 \
    libfribidi-dev \
    libharfbuzz-dev \
    libfreetype-dev \
    libtiff-dev libjpeg-dev libpng-dev \
    libfontconfig1-dev \
    bzip2 liblzma-dev liblzma5 \
    curl wget \
    ncurses-base libncurses-dev \
    gettext \
    libfuse3-3 libfuse3-dev fuse \
    software-properties-common \
    xauth \
    shellcheck \
    zip unzip \
    python3-pip \
    vim

# R
RUN apt update -qq && \
    apt install --no-install-recommends dirmngr && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
    | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    apt-get install -y r-base r-base-dev

# get python 3.10
# install current version of pip to /home/ubuntu/.local/lib/python3.10/
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt update -y && \
    apt-get install -y python3.10-full python3.10-dev \
        python3.10-distutils \
        python3-pip \
        python3-venv \
        python3.10-dev \
        python3.10-distutils \
        python3.10-venv

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | \
    tar -xvj bin/micromamba && \
    mv ${HOME}/bin/micromamba /usr/local/bin/ && \
    rm -rf ${HOME}/bin && \
    pip install conda-lock

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt install -y nodejs

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

# R packages
RUN R -e "repo = 'http://cran.us.r-project.org'; \
    install.packages('remotes', repos = repo); \
    remotes::install_cran('ragg', repos = repo, upgrade = 'never'); \
    remotes::install_cran('languageserver', repos = repo, upgrade = 'never'); \
    remotes::install_cran('lintr', repos = repo, upgrade = 'never'); \
    remotes::install_cran('styler', repos = repo, upgrade = 'never'); \
    remotes::install_cran('devtools', repos = repo, upgrade = 'never'); \
    remotes::install_cran('tidyverse', repos = repo, upgrade = 'never')"

# python packages
RUN pip3 install --no-cache-dir \
        pyright \
        black \
        flake8 \
        pandas \
        numpy \
        ipython \
        tqdm \
        ipywidgets \
        radian \
        datasets \
        umap-learn \
        scikit-learn \
        matplotlib && \
    rm -rf "$cache_dir"

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

RUN npm i -g bash-language-server

# run with:
# sudo docker run --rm --gpus=all --ipc=host --detach-keys "ctrl-p" \
#   --ulimit memlock=-1 --ulimit stack=67108864 -it -e TERM=xterm-256color \
#   -v /home/ubuntu/:/home/ubuntu/ 752f69a63279 /bin/bash
