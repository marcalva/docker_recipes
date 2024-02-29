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

RUN apt-get install -y man-db manpages \
    shellcheck \
    python3-pip \
    zip \
    unzip \
    wget \
    curl

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

COPY environment.yml ${HOME}/
RUN micromamba create -y -f environment.yml && \
    micromamba clean -afy

# RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
#     apt install -y nodejs
# 
# RUN npm i -g bash-language-server
# 
# # fzf
# RUN cd $HOME && \
#     git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
#     .fzf/install \
#         --all \
#         --key-bindings \
#         --completion \
#         --update-rc \
#         --no-zsh \
#         --no-fish
# 
# # rust
# RUN cd $HOME && \
#     echo "$HOME" && \
#     cat /etc/bash.bashrc && \
#     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rust_i.sh && \
#     chmod u+x rust_i.sh && \
#     ./rust_i.sh -y && \
#     rm rust_i.sh
# 
# # bat, ripgrep, fd-find
# RUN cd $HOME && \
#     . "$HOME/.cargo/env" && \
#     echo $PATH && \
#     cargo install --locked bat && \
#     cargo install ripgrep && \
#     cargo install fd-find && \
#     cargo install shellharden
# 
# # neovim
# RUN wget "https://github.com/neovim/neovim/archive/refs/tags/nightly.tar.gz" && \
#     tar -xzf nightly.tar.gz && \
#     rm nightly.tar.gz && \
#     cd ./neovim-nightly && \
#     make CMAKE_BUILD_TYPE=Release && \
#     make install && \
#     cd ../ && \
#     rm -rf neovim-nightly
# 
# RUN mkdir -p .config/ && cd .config/ && \
#     git clone  https://github.com/marcalva/nvim_config.git nvim && \
#     cd ../ && \
#     nvim -c 'Lazy install' -c 'sleep 20' -c qa --headless
# 
# VOLUME /workspace
# WORKDIR /workspace
# 
