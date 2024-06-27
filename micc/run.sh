sudo docker run --rm --ipc=host -it --detach-keys="ctrl-x" \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
    -e GH_USERNAME=$GH_USERNAME \
    -e GH_EMAIL=$GH_EMAIL \
    -e GH_TOKEN=$GH_TOKEN \
    -v $HOME:/workspace \
    -v $HOME/.gitconfig:/home/ubuntu/.gitconfig \
    -v $HOME/.config/github-copilot/:/home/ubuntu/.config/github-copilot/ \
    ghcr.io/marcalva/micc:1.2 /bin/bash
