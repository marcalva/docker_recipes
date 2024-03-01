#!/usr/bin/env bash

set -ef -o pipefail

source /usr/local/bin/_mamba_sh.sh

micromamba activate py_base

echo "micromamba activate py_base" >> ${HOME}/.bashrc

exec "$@"
