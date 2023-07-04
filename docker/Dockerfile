FROM ubuntu:20.04


WORKDIR /root

COPY in.sh in.sh
RUN ./in.sh

COPY gcc.sh gcc.sh
RUN ./gcc.sh

COPY python.sh python.sh
RUN ./python.sh
COPY cmake.sh cmake.sh
COPY conan.sh conan.sh
RUN ./cmake.sh

RUN ./conan.sh


COPY entrypoint.sh entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]



# COPY build.sh build.sh
# RUN ./build.sh
# RUN apt-get install python3-pip python-is-python3
## or
##curl https://pyenv.run | bash
##export PYENV_ROOT="$HOME/.pyenv"
##command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
##eval "$(pyenv init -)"
##
##pyenv install 3.11.2
##pyenv global 3.11.2

#pip install --upgrade pip
#pip install conan==${conan_version}
#pip install conan<2 # ${conan_version}
# conan_version=${CONAN_VERSION:-1.60}
#conan profile new --detect gcc
#conan profile update settings.compiler=gcc gcc
#conan profile update settings.compiler.version=${gcc_version} gcc
#conan profile update settings.compiler.libcxx=libstdc++11 gcc
#conan profile update settings.compiler.cppstd=20 gcc
#conan profile update env.CC=/usr/bin/gcc gcc
#conan profile update env.CXX=/usr/bin/g++ gcc
