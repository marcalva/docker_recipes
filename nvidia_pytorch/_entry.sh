#!/usr/bin/env bash

set -ef -o pipefail

source /usr/local/bin/_mamba_sh.sh

exec "$@"
