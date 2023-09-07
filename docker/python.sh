#!/usr/bin/env bash

set -o errexit
set -o xtrace

python_version=${PYTHON_VERSION:-3.11.4}

curl https://pyenv.run | bash
echo 'export PYENV_ROOT="/root/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="~/.pyenv/bin:$PATH"'>> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile

. ~/.profile

pyenv install $python_version
pyenv global $python_version
