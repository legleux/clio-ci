## Clio packages
The Clio repository contains only the source code and unit tests for the Clio server. The packaging code is contained in the [clio-packages](https://github.com/XRPLF/clio-packages.git). Github Actions for building and packaging Clio exist in the [clio-gha repository](https://github.com/XRPLF/clio-gha.git). These other repositories allow the actions defined in the Clio repo itself to be simple and any changes do not require any modification of the Clio souce itself.The XRPLF organization has acess to self-hosted GitHub runners with much better specs that what GitHub provides for free.

When a pull-request or push is made to the Clio repo, the Action for building the project checks out the clio-packages repo in a directory next to the Clio source. The clio-packages project builds Clio using CMake's [ExternalProject](https://cmake.org/cmake/help/v3.16/module/ExternalProject.html) by copying the source passed in via a `CLIO_ROOT` environment variable or defined by the configure (`-DCLIO_ROOT=<clio_src_dir>`). The clio-packages repo uses the `PATCH_COMMAND` step of CMake’s ExternalProject to overlay the packaging CMake code into the repository as if it were one repo.

The current pipeline lints the Clio source with clang-format, builds the `clio_server`, `clio_tests` and clio packages then runs the `clio_tests` executable. The `clio_server` executable is provided by a `clio_server` package while the `clio` package provides clio_server with a [`rippled`](https://github.com/XRPLF/ripple.git) configured to work with the server.
Packages are are currently only available as apt packages for Debian based systems.

The build is performed using GCC-11 on Ubuntu 20.04 requiring the [clio dependencies](https://github.com/XRPLF/clio#building).

Packages can be installed by adding Ripple's gpg key and deb repo and updating apt's sources

    $ sudo apt-get install -y wget gpg

    $ sudo mkdir /usr/local/share/keyrings/
    $ wget -q -O - "https://repos.ripple.com/repos/api/gpg/key/public" | gpg --dearmor > ripple-key.gpg
    $ sudo mv ripple-key.gpg /usr/local/share/keyrings
    $ echo "deb [signed-by=/usr/local/share/keyrings/ripple-key.gpg] https://repos.ripple.com/repos/rippled-deb focal stable" | \
        sudo tee -a /etc/apt/sources.list.d/ripple.list

    $ sudo apt update && apt search clio
    Sorting... Done
    Full Text Search... Done
    clio/focal 1.0.1 all
    Clio API server with rippled configured

    clio-server/focal 1.0.1-1 amd64
    Clio XRPL API server
