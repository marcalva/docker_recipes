gpus=""
if type nvidia-smi &> /dev/null; then
    if nvidia-smi &> /dev/null; then
         gpus="--gpus all"
    fi
fi

sudo docker run --rm $gpus --ipc=host -it --detach-keys="ctrl-q" \
    -v $HOME:/workspace \
    -v $HOME/.gitconfig:/home/ubuntu/.gitconfig \
    -v $HOME/.config/github-copilot/:/home/ubuntu/.config/github-copilot/ \
    $HOME:/workspace ghcr.io/marcalva/scfm:1.2 /bin/bash
