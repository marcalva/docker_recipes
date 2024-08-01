gpus=""
if type nvidia-smi &> /dev/null; then
    if nvidia-smi &> /dev/null; then
         gpus="--gpus all"
    fi
fi

sudo docker run --rm $gpus --ipc=host -it --detach-keys="ctrl-@" \
    -v $HOME:/workspace ghcr.io/marcalva/nvidia_pytorch:1.2 /bin/bash
