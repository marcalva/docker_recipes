#!/usr/bin/env bash

set -ef -o pipefail

source /usr/local/bin/_mamba_sh.sh

micromamba activate pytorch

echo "micromamba activate pytorch" >> ${HOME}/.bashrc

exec "$@"
