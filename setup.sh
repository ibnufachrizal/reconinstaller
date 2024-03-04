#!/usr/bin/env bash

clear
banner="
██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝"
echo "$banner"
echo "by @ibnufachrizal"

GREEN='\033[0;32m'
NC='\033[0m'

mkdir ~/op
location=$(pwd)

if [ `whoami` != root ]; then
    echo Please this script as root or using sudo
    exit
fi

echo -e "${GREEN}[*] Installing Golang${NC}"

eval wget https://golang.org/dl/go1.21.3.linux-amd64.tar.gz
eval tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz
eval ln -sf /usr/local/go/bin/go /usr/local/bin/
rm -rf go1.21.3.linux-amd64.tar.gz
    
cat << EOF >> ~/.zshrc
# Environment Golang
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$GOPATH/bin:\$GOROOT/bin:\$HOME/.local/bin:\$PATH
EOF

echo -e "${GREEN}[*] Installing Essentials${NC}"
apt-get install --allow-unauthenticated -y --no-install-recommends \
    awscli \
    build-essential \
    curl \
    curl \
    dnsutils \
    gcc \
    git \
    inetutils-ping \
    jq \
    libpcap-dev \
    make \
    net-tools \
    netcat \
    nikto \
    nmap \
    perl \
    python3-pip \
    python3 \
    wget \
    whois

echo -e "${GREEN}[*] Downloading Wordlists${NC}"
git clone https://github.com/xm1k3/cent.git ~/op/cent
git clone https://github.com/ayoubfathi/leaky-paths.git ~/op/leaky-paths
wget -q -O ~/op/best-dns-wordlist.txt https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt
wget -q -O ~/op/permutations.txt https://gist.github.com/six2dez/ffc2b14d283e8f8eff6ac83e20a3c4b4/raw
wget -q -O ~/op/resolvers.txt https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt
git clone https://github.com/danielmiessler/SecLists.git ~/op/seclists

echo -e "${GREEN}[*] Installing Tools${NC}"
pip3 install arjun
pip3 install dirsearch
pip install git-dumper
git clone https://github.com/blechschmidt/massdns.git /tmp/massdns; cd /tmp/massdns; make -s; mv bin/massdns /usr/bin/massdns
go install -v github.com/tomnomnom/waybackurls@latest > /dev/null
go install -v github.com/hakluke/hakrawler@latest > /dev/null
go install -v github.com/lc/gau/v2/cmd/gau@latest > /dev/null
go install -v github.com/jaeles-project/gospider@latest > /dev/null
go install -v github.com/owasp-amass/amass/v4/...@master > /dev/null
go install -v github.com/ffuf/ffuf/v2@latest > /dev/null
go install -v github.com/hahwul/dalfox/v2@latest > /dev/null
go install -v github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest > /dev/null
go install -v github.com/sa7mon/s3scanner@latest > /dev/null
go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest > /dev/null
go install -v github.com/tomnomnom/gf@latest > /dev/null
go install -v github.com/tomnomnom/qsreplace@latest > /dev/null
go install -v github.com/tomnomnom/anew@latest > /dev/null
go install -v github.com/tomnomnom/unfurl@latest > /dev/null
go install -v github.com/tomnomnom/hacks/inscope@latest > /dev/null
go install -v github.com/tomnomnom/assetfinder@latest > /dev/null
go install -v github.com/tomnomnom/meg@latest > /dev/null
source ~/.zshrc

echo -e "${GREEN}[*] Installing All Tools ProjectDiscovery${NC}"
echo "Installing all pdtm tools..."
pdtm -ia
source ~/.bashrc

echo -e "${GREEN}[*] Update Nuclei-Templates${NC}"
nuclei -update-templates

echo -e "${GREEN}[*] Clean up${NC}"
rm $location/setup.sh
apt-get clean

echo -e "${GREEN}[*] Installation Complete! ${NC}"
echo -e "${GREEN}[*] Your wordlists have been saved in: "$HOME/op${NC}"
