#!/bin/bash

# This runs on the server

chef_binary=/usr/local/bin/chef-solo

# Are we on a vanilla system?
if  test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    # apt-get -y install aptitude
    aptitude update &&
    apt-get -o Dpkg::Options::="--force-confnew" \
        --force-yes -fuy dist-upgrade &&

    apt-get -y install build-essential g++ libruby1.8 ruby1.8 libreadline5-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libyaml-dev &&

    if ! test -f ruby-1.9.3-p0.tar.gz; then
       wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz
    fi &&
    tar zxf ruby-1.9.3-p0.tar.gz &&
    cd ruby-1.9.3-p0 &&
    ./configure --with-baseruby=/usr/bin/ruby1.8 &&
    make clean &&
    make &&
    make install &&
    gem install --no-rdoc --no-ri chef --version 0.10.0
fi &&

"$chef_binary" -c solo.rb -j solo.json