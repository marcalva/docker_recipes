# Build a docker file from the NVIDIA PyTorch image
FROM nvcr.io/nvidia/pytorch:24.01-py3

# install
RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update -y

RUN apt-get install -y systemd

ENV TZ="US/Pacific"

RUN apt-get install -y \
    build-essential \
    autoconf automake libtool autotools-dev libtool-bin \
    cmake \
    clangd \
    gdb \
    dpkg-repack \
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
    curl \
    ncurses-base libncurses-dev \
    gettext \
    libfuse3-3 libfuse3-dev fuse \
    software-properties-common \
    xauth \
    shellcheck

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt install -y nodejs

RUN add-apt-repository ppa:neovim-ppa/stable && \
    apt-get update && \
    apt-get install neovim

# ENV NVIM_REPO="https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
# 
# RUN cd $HOME && wget $NVIM_REPO && \
#     chmod u+x nvim.appimage && \
#     ./nvim.appimage --appimage-extract && \
#     mv ./squashfs-root/usr/bin/nvim /usr/local/bin/nvim && \
#     mv nvim.appimage /usr/local/bin/nvim

RUN cd $HOME && mkdir -p .config/ && cd .config/ && \
    git clone  https://github.com/marcalva/nvim_config.git nvim && \
    cd ../ && \
    nvim -c 'Lazy install' -c 'sleep 20' -c qa --headless

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

RUN apt-get install -y \
    python3.10-dev \
    python3.10-distutils \
    python3.10-venv

RUN cache_dir=$(mktemp -d -p "$PWD") && \
    pip3 install --cache-dir "$cache_dir" pandas \
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

# R
RUN apt install -y --no-install-recommends dirmngr
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
    | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt-get install -y r-base r-base-core r-recommended r-base-dev

RUN R -e "repo = 'http://cran.us.r-project.org'; \
    install.packages('remotes', repos = repo); \
    remotes::install_cran('ragg', repos = repo, upgrade = 'never'); \
    remotes::install_cran('languageserver', repos = repo, upgrade = 'never'); \
    remotes::install_cran('lintr', repos = repo, upgrade = 'never'); \
    remotes::install_cran('styler', repos = repo, upgrade = 'never'); \
    remotes::install_cran('devtools', repos = repo, upgrade = 'never'); \
    remotes::install_cran('tidyverse', repos = repo, upgrade = 'never')"

RUN cd $HOME && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rust_i.sh && \
    chmod u+x rust_i.sh && \
    ./rust_i.sh -y && \
    rm rust_i.sh && \
    . .bashrc

# bat, ripgrep, fd-find
RUN cd $HOME && \
    . "$HOME/.cargo/env" && \
    echo $PATH && \
    cargo install --locked bat && \
    cargo install ripgrep && \
    cargo install fd-find

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

# mamba
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | \
    tar -xvj  bin/micromamba && \
    mv bin/micromamba /usr/local/bin/ && \
    rm -rf bin

COPY ./my_bashrc.sh /home/ubuntu/my_bashrc.sh

RUN cat /home/ubuntu/my_bashrc.sh >> /root/.bashrc

# run with:
# sudo docker run --rm --gpus=all --ipc=host --detach-keys "ctrl-p" \
#   --ulimit memlock=-1 --ulimit stack=67108864 -it -e TERM=xterm-256color \
#   -v /home/ubuntu/:/home/ubuntu/ 752f69a63279 /bin/bash
