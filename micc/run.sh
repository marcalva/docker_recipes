sudo docker run --rm --ipc=host -it --detach-keys="ctrl-x" \
    -v $HOME:/workspace \
    -v $HOME/.gitconfig:/home/ubuntu/.gitconfig \
    -v $HOME/.config/github-copilot/:/home/ubuntu/.config/github-copilot/ \
    ghcr.io/marcalva/micc:1.0 /bin/bash
