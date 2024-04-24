sudo docker run --rm --ipc=host -it --detach-keys="ctrl-@" \
    -v $HOME:/workspace ghcr.io/marcalva/sicca:1.0 /bin/bash
