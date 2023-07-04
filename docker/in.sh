apt-get update && \
    apt-get install -y software-properties-common

add-apt-repository -y ppa:ubuntu-toolchain-r/test

apt-get update && \
    apt-get install -y git curl vim pkg-config  libbz2-dev liblzma-dev libsqlite3-dev build-essential libssl-dev zlib1g-dev \
    libreadline-dev  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev
