#!/usr/bin/env bash

clear
echo "by @ibnufachrizal\n"
location=$(pwd)

# Setup Shell
read -n 1 -p "What shell are you using? zsh or bash? (z/b) " opt;

if [[ "$opt" == *"z"* ]]; then
        shell=.zshrc
elif [[ "$opt" == *"b"* ]]; then
        shell=.bashrc
fi

echo "Shell is now equal to $shell"

if [ `whoami` != root ]; then
    echo Please this script as root or using sudo
    exit
fi

#Install golang:

echo "Installing/Updating Golang"

if [[ $(eval type go $DEBUG_ERROR | grep -o "go is") == "go is" ]]
    then
        echo "Golang is already installed and updated"
    else 
        eval wget https://golang.org/dl/go1.21.3.linux-amd64.tar.gz
        eval tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz
fi
        eval ln -sf /usr/local/go/bin/go /usr/local/bin/
    rm -rf go1.21.3.linux-amd64.tar.gz


cat << EOF >> ~/${profile_shell}/$shell 

# Golang vars
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$GOPATH/bin:\$GOROOT/bin:\$HOME/.local/bin:\$PATH
EOF

# Install python
apt-get update
apt-get install --allow-unauthenticated -y \
    python3.10 \
    python3-dev \
    python3-pip jq

# Install essential packages
apt-get install --allow-unauthenticated -y --no-install-recommends \
    build-essential \
    cmake \
    geoip-bin \
    geoip-database \
    gcc \
    git \
    libpq-dev \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libpcap-dev \
    netcat \
    nmap \
    x11-utils \
    xvfb \
    wget \
    curl \
    python3-netaddr \
    software-properties-common

mkdir $location/op

# Download Wordlists
echo "Downloading Wordlists"

git clone https://github.com/xm1k3/cent.git $location/op/cent
git clone https://github.com/ayoubfathi/leaky-paths.git $location/op/leaky-paths
git clone https://github.com/0xtavian/minimal-pentesting-dockerfiles.git $location/op/axiom-dockerfiles
wget -q -O $location/op/permutations.txt https://gist.github.com/six2dez/ffc2b14d283e8f8eff6ac83e20a3c4b4/raw
wget -q -O $location/op/resolvers.txt https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt
git clone https://github.com/danielmiessler/SecLists.git $location/op/seclists


# Download Tools packages
echo "Installing Tools"

pip3 install arjun
git clone https://github.com/blechschmidt/massdns.git /tmp/massdns; cd /tmp/massdns; make -s; mv bin/massdns /usr/bin/massdns
go install -v github.com/tomnomnom/anew@latest > /dev/null
go install -v github.com/jaeles-project/gospider@latest > /dev/null
go install -v github.com/tomnomnom/gf@latest > /dev/null
go install -v github.com/tomnomnom/unfurl@latest > /dev/null
go install -v github.com/tomnomnom/waybackurls@latest > /dev/null
go install -v github.com/hakluke/hakrawler@latest > /dev/null
go install -v github.com/lc/gau/v2/cmd/gau@latest > /dev/null
go install -v github.com/jaeles-project/gospider@latest > /dev/null
go install -v github.com/owasp-amass/amass/v3/...@latest > /dev/null
go install -v github.com/ffuf/ffuf@latest > /dev/null
go install -v github.com/projectdiscovery/tlsx/cmd/tlsx@latest > /dev/null
go install -v github.com/hahwul/dalfox/v2@latest > /dev/null
go install -v github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest > /dev/null
go install -v github.com/sa7mon/s3scanner@latest > /dev/null
go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest > /dev/null
source ~/${profile_shell}/$shell

# Installing All Tools ProjectDiscovery
echo "Installing all pdtm tools..."
pdtm -ia

# Update Nuclei and Nuclei-Templates
nuclei -update
nuclei -update-templates

echo "Installation finished. Enjoy!"
