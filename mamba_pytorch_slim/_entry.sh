#!/usr/bin/env bash

set -ef -o pipefail

source /usr/local/bin/_mamba_sh.sh

micromamba create -y -n pytorch -f /opt/conda/pytorch_conda-lock.yml && \
    micromamba clean -afy && \
    micromamba clean --index-cache

micromamba activate pytorch

echo "micromamba activate pytorch" >> ${HOME}/.bashrc

exec "$@"
