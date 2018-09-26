#!/bin/bash

source extern_functions.sh

DEV_DEPS="automake \
         autoconf \
         libgflags-dev \
         build-essential \
         clang \
         curl \
         g++-6 \
         git \
         libjudy-dev \
         libgmp-dev \
         libpcap-dev \
         libboost-dev \
         libboost-program-options-dev \
         libboost-system-dev \
         libboost-filesystem-dev \
         libboost-thread-dev \
         libboost-iostreams-dev \
         libboost-graph-dev \
         libtool \
         tar \
         ca-certificates \
         libreadline-dev \
         bison \
         flex \
         libfl-dev \
         bzip2 \
         pkg-config \
	       libssl-dev \
         python-setuptools \
         python-pip \
         libpython2.7-dev \
         libgflags-dev \
         cmake \
	       libevent-dev"

RUN_DEPS="sudo \
	 libboost-program-options1.58.0 \
	 libboost-system1.58.0 \
   libboost-filesystem1.58.0 \
   libboost-thread1.58.0 \
   libgmp10 \
   libjudydebian1 \
   libpcap0.8 \
	 net-tools \
	 python \
   python-scapy \
   scapy \
	 tcpdump"

ROOT=$(pwd)

c_print "blue" "Updating python-pip"
sudo -H pip install --upgrade pip
c_print "green" "[DONE]"

c_print "blue" "Installing developing dependencies..."
sudo apt-get install -y --no-install-recommends $DEV_DEPS
c_print "green" "[OK]"

c_print "blue" "Installing running dependencies..."
sudo apt-get install -y --no-install-recommends $RUN_DEPS
c_print "green" "[OK]"


c_print "blue" "Download behavioral model..."
git clone https://github.com/p4lang/behavioral-model/

c_print "bold" "Skipping install-dep script as it fails most of the time!"
c_print "bold" "We do it manually!"



echo ""
c_print "blue" "Installing thrift 0.9.2"
cd behavioral-model/travis/
wget http://archive.apache.org/dist/thrift/0.9.2/thrift-0.9.2.tar.gz
tar -xzvf thrift-0.9.2.tar.gz
cd thrift-0.9.2
./configure --with-cpp=yes --with-c_glib=no --with-java=no --with-ruby=no --with-erlang=no --with-go=no --with-nodejs=no --enable-tests=no
make -j2
sudo make install
cd lib/py
sudo -H python setup.py install
cd ..
c_print "green" "[OK]"



echo ""
c_print "blue" "DEP BMV2: Installing nanomsg"
wget https://github.com/nanomsg/nanomsg/archive/1.0.0.tar.gz -O nanomsg-1.0.0.tar.gz
tar -xzvf nanomsg-1.0.0.tar.gz
cd nanomsg-1.0.0
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --build . --target install
cd ..
c_print "green" "[DONE]"


echo ""
c_print "blue" "DEP BMV2: Installing nnpy"
git clone https://github.com/nanomsg/nnpy.git
cd nnpy
git checkout c7e718a5173447c85182dc45f99e2abcf9cd4065
sudo pip install cffi
sudo pip install .
cd ..
c_print "green" "[DONE]"

cd $ROOT
sudo ldconfig

echo ""

c_print "blue" "DEP P4runtime: Installing protobuf"
git clone https://github.com/google/protobuf.git
cd protobuf/
git checkout tags/v3.2.0
./autogen.sh
./configure
make -j2
sudo make install
sudo ldconfig
c_print "green" "[DONE]"

cd $ROOT

c_print "blue" "DEP P4runtime: Installing grpc"
git clone https://github.com/google/grpc.git
cd grpc/
git checkout tags/v1.3.2
git submodule update --init --recursive
make -j2
make grpc_cli
sudo make install
sudo ldconfig
cp bins/opt/grpc_cli /usr/bin/
c_print "green" "[DONE]"

cd $ROOT
git clone https://github.com/p4lang/PI/
cd PI/
git submodule update --init --recursive
./autogen.sh
./configure --with-proto --with-cli --without-internal-rpc
make -j2
sudo make install
sudo ldconfig
c_print "green" "[DONE]"

cd $ROOT
c_print "blue" "Installing the BMV2 itself"
cd behavioral-model/
./autogen.sh
./configure --with-pi --with-thrift --with-nanomsg --with-pdfixed
make -j2
sudo make install
sudo ldconfig
c_print "green" "[DONE]"

echo ""
c_print "blue" "Install simple_switch_grpc"
cd targets/simple_switch_grpc/
./autogen.sh
./configure
make
sudo make install
c_print "green" "[DONE]"


cd $ROOT
echo ""
c_print "blue" "Install p4c compiler"
git clone --recursive https://github.com/p4lang/p4c.git
cd p4c
mkdir build
cd build
cmake ..
make -j2
sudo make install
sudo ldconfig
c_print "green" "[DONE]"
cd $ROOT

c_print "green" "EVERYTHING IS INSTALLED"
c_print "white" "Check whether you have the following binaries:"
c_print "bold"  "P4 compiler: " 1
c_print "yellow" "p4c, p4c-bm2-psa, p4c-bm2-ss p4c-ebpf, p4c-graphs"
c_print "bold"  "P4 software switch: " 1
c_print "yellow" "simple_switch, simple_switch_grpc, simple_switch_CLI"
echo ""
