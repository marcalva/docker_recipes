sudo docker run --rm --ipc=host -it --detach-keys="ctrl-@" \
    -v $HOME:/workspace ghcr.io/marcalva/ubuntu_base:1.2 /bin/bash
