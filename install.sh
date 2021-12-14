#!/bin/bash

# stops when a command fails
set -e 
set -o pipefail

# make the client lib
mkdir lib/build && cd lib/build
cmake ..
make install
cd..

# make the examples that use the client lib
for dir in examples/*; do 
    mkdir examples/${dir}/build && cd examples/${dir}/build
    cmake ..
    make install  &
    cd ..
done

# make the server
cd server
make
make install 
cd ..

# make the kernel modules
cd kmods/fred_buffctl
make
make install 
cd ..

cd kmods/xdevcfg_mod
make
make install 
cd ..
