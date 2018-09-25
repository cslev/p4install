#!/bin/bash

source extern_functions.sh

DEV_DEPS="automake \
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
         libtool \
         pkg-config \
	 libssl-dev \
         python-setuptools \
         python-pip \
         libpython2.7-dev \
	 libevent-dev

RUN_DEPS=sudo \
	 libboost-program-options1.58.0 \
	 libboost-system1.58.0 \
         libboost-filesystem1.58.0 \
         libboost-thread1.58.0 \
         libgmp10 \
         libjudydebian1 \
         libpcap0.8 \
	 net-tools \
	 python \
	 scapy \
	 tcpdump

c_print "green" "test"
