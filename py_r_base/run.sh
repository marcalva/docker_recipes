sudo docker run --rm --ipc=host -it --detach-keys="ctrl-@" \
    -v $HOME:/workspace ghcr.io/marcalva/py_r_base:1.0 /bin/bash
