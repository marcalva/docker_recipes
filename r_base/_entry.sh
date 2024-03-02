#!/usr/bin/env bash

set -ef -o pipefail

source /usr/local/bin/_mamba_sh.sh

micromamba activate r_base

echo "micromamba activate r_base" >> ${HOME}/.bashrc

exec "$@"
