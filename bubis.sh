#!/bin/bash -i
# Author: w4rh0und
# Date: 04/10/2024

# Check if the script executed as root
if [ "${UID}" -eq 0 ]
then
    echo ""; echo -e "\e[32m\e[1mOK. The script will install the tools.\e[0m\e[39m"; echo "";
else
    echo ""; echo -e "\e[91m\e[1mRoot privileges are required\e[0m\e[39m"; echo "";
    exit
fi

#---------Update, upgrade, & tidy up
echo -e "\e[93m\e[1m----> Updating all Packages. Cleaning up too.";
apt-get update -y && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y
echo -e "\e[32mDone!";
sleep 1.5
clear;

#---------Shell(Zsh)
echo -e "\e[93m\e[1m----> Installing Zsh";
apt-get install -y zsh
chsh -s $(which zsh) && su - $USER
echo -e "\e[32mDone!";
sleep 1.5
clear;
#---------Shell Accessories
#---------oh-my-zsh
echo -e "\e[93m\e[1m----> Installing Oh-My-Zsh";
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#Figure out how to automate or get around the oh-my-zsh installer here
#Maybe just pull my ~/.oh-my-zsh over?
echo -e "\e[32mDone!";

#---------Install essentials
echo -e "\e[93m\e[1m----> Installing essential packages";
apt-get install -y git rename findutils make gcc mlocate apt-transport-https curl
echo -e "\e[32mDone!";
sleep 1.5

#Python, ruby, go, etc.
echo -e "\e[93m\e[1m----> Installing Python,Ruby and some other required packages";
apt-get install -y python3 python3-pip ruby-full golang-go 
echo -e "\e[32mDone!";
sleep 1.5

#--------Network
#tor
echo -e "\e[93m\e[1m----> Installing tor";
dpkg --print-architecture > $1;
touch /etc/apt/sources.list.d/tor.list && echo "
    deb     [arch=$1 signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org focal main
    deb-src [arch=$1 signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org focal main
" > /etc/apt/sources.list.d/tor.list;
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null;
apt-get update & apt-get install -y tor deb.torproject.org-keyring;
echo -e "\e[32mDone!";
sleep 1.5

#Proxychains
echo -e "\e[93m\e[1m----> Installing Proxychains4";
apt-get install -y proxychains4
echo -e "\e[32mDone!";
sleep 1.5

#Mullvad
echo -e "\e[93m\e[1m----> Installing Mullvad";
curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/mullvad.list
apt-get update && apt-get install mullvad-vpn
echo -e "\e[32mDone!";
sleep 1.5
##---------Install Go
##Rewrite Go installer to get the latest version and do this process faster
#echo -e "\e[93m\e[1m----> Golang environment installation in progress ...";
#cd /tmp && wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz > /dev/null 2>&1 && tar xvf go1.21.6.linux-amd64.tar.gz > /dev/null 2>&1;
#mv go /usr/local
#export GOROOT=/usr/local/go && export GOPATH=$HOME/go && export PATH=$GOPATH/bin:$GOROOT/bin:$PATH;
#echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile && echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile	&& echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile;
#source ~/.bash_profile
#echo -e "\e[32mGolang environment installation is done !"; echo "";
#sleep 1.5

#---------Tools
#---------Netscanners
#Nmap
echo -e "\e[93m\e[1m----> Installing nmap";
apt-get install -y nmap > /dev/null 2>&1;
echo -e "\e[32mDone! Nmap installed.";
sleep 1.5
#Masscan
echo -e "\e[93m\e[1m----> Installing Masscan";
git clone https://github.com/robertdavidgraham/masscan > /dev/null 2>&1 && cd masscan && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && mv bin/masscan /usr/local/bin/;
echo -e "\e[32mDone! Masscan installed."; echo "";
sleep 1.5
#Naabu
echo -e "\e[93m\e[1m----> Installing Naabu";
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest > /dev/null 2>&1 && ln -s ~/go/bin/naabu /usr/local/bin/;
echo -e "\e[32mDone! Naabu installed."; echo "";
sleep 1.5

#---------Subdomain Enum + DNS Resolver
#dnsutils
apt-get install -y dnsutils > /dev/null 2>&1;
sleep 1.5
#Massdns
echo -e "\e[93m\e[1m----> Installing massdns";
git clone https://github.com/blechschmidt/massdns.git > /dev/null 2>&1;
cd ~/tools/massdns
make > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! Massdns installed."; echo "";
sleep 1.5
#Subfinder
echo -e "\e[93m\e[1m----> Installing Subfinder";
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest > /dev/null 2>&1 && ln -s ~/go/bin/subfinder /usr/local/bin/;
echo -e "\e[32mDone! Subfinder installed."; echo "";
sleep 1.5
#Knock
echo -e "\e[93m\e[1m----> Installing Knock";
git clone https://github.com/guelfoweb/knock.git > /dev/null 2>&1;
echo -e "\e[32mDone! Knock installed."; echo "";
sleep 1.5
#Lazyrecon
echo -e "\e[93m\e[1m----> Installing LazyRecon";
git clone https://github.com/nahamsec/lazyrecon.git > /dev/null 2>&1;
echo -e "\e[32mDone! LazyRecon installed."; echo "";
sleep 1.5
#Github-subdomains
echo -e "\e[93m\e[1m----> Installing Github-subdomains";
go install github.com/gwen001/github-subdomains@latest > /dev/null 2>&1 && ln -s ~/go/bin/github-subdomains /usr/local/bin/;
echo -e "\e[32mDone! Github-subdomains installed."; echo "";
sleep 1.5
#Sublist3r
echo -e "\e[93m\e[1m----> Installing Sublist3r";
git clone https://github.com/aboul3la/Sublist3r.git > /dev/null 2>&1;
cd Sublist3r*
pip3 install -r requirements.txt
cd ~/tools/
echo -e "\e[32mDone! Sublist3r installed."; echo "";
sleep 1.5
#Crtndstry
echo -e "\e[93m\e[1m----> Installing Crtndstry";
git clone https://github.com/nahamsec/crtndstry.git > /dev/null 2>&1;
echo -e "\e[32mDone! Crtndstry installed."; echo "";
sleep 1.5
#Assetfinder
echo -e "\e[93m\e[1m----> Installing Assentfinder";
go install github.com/tomnomnom/assetfinder@latest > /dev/null 2>&1 && ln -s ~/go/bin/assetfinder /usr/local/bin/;
echo -e "\e[32mDone! Assetfinder installed."; echo "";
sleep 1.5
#dnsx
echo -e "\e[93m\e[1m----> Installing Dnsx";
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest > /dev/null 2>&1 && ln -s ~/go/bin/dnsx /usr/bin/;
echo -e "\e[32mDone! Dnsx installed."; echo "";
sleep 1.5
#dnsgen
echo -e "\e[93m\e[1m----> Installing Dnsgen";
pip3 install dnsgen > /dev/null 2>&1;
echo -e "\e[32mDone! Dnsgen installed."; echo "";
sleep 1.5
#---------Fuzzing
#Dirsearch
echo -e "\e[93m\e[1m----> Installing dirsearch";
git clone https://github.com/maurosoria/dirsearch.git > /dev/null 2>&1;
cd dirsearch*
pip3 install -r requirements.txt
cd ~/tools/
echo -e "\e[32mDone! Dirsearch installed.";
sleep 1.5
#ffuf
echo -e "\e[93m\e[1m----> Installing ffuf";
go install -v github.com/ffuf/ffuf@latest > /dev/null 2>&1 && ln -s ~/go/bin/ffuf /usr/local/bin/;
echo -e "\e[32mDone! Ffuf installed.";
sleep 1.5

#---------Wordlists
echo -e "\e[93m\e[1m----> Downloading Seclists";
cd ~/tools/
git clone https://github.com/danielmiessler/SecLists.git > /dev/null 2>&1;
cd ~/tools/SecLists/Discovery/DNS/
#This file must be cleaned, as it breaks massdns
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
rm dns-Jhaddix.txt
cd ~/tools/
echo -e "\e[32mDone! Seclists downloaded."; echo "";
sleep 1.5

#---------CMS
#WPScan
echo -e "\e[93m\e[1m----> Installing wpscan";
gem install wpscan > /dev/null 2>&1;
echo -e "\e[32mDone! wpscan installed."; echo "";
sleep 1.5
#Droopescan
echo -e "\e[93m\e[1m----> Installing Droopescan";
pip3 install droopescan > /dev/null 2>&1;
echo -e "\e[32mDone! Droopescan installed."; echo "";
sleep 1.5

#---------SQL
#SQLmap
echo -e "\e[93m\e[1m----> Installing sqlmap";
apt-get install -y sqlmap > /dev/null 2>&1;
echo -e "\e[32mDone! Sqlmap installed."; echo "";
sleep 1.5
#NoSQLMap
echo -e ${BLUE}"[VULNERABILITY - SQL Injection]" ${RED}"NoSQLMap installation in progress ...";
git clone https://github.com/codingo/NoSQLMap.git > /dev/null 2>&1;
cd NoSQLMap
python setup.py install > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! NoSqlmap installed."; echo "";
sleep 1.5
#Jeeves
echo -e "\e[93m\e[1m----> Installing Jeeves";
go install -v github.com/ferreiraklet/Jeeves@latest > /dev/null 2>&1 && ln -s ~/go/bin/jeeves /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Jeeves installed."; echo "";
sleep 1.5

#---------JS Enumeration
#LinkFinder
echo -e "\e[93m\e[1m----> Installing LinkFinder";
git clone https://github.com/GerbenJavado/LinkFinder.git > /dev/null 2>&1;
cd LinkFinder
pip3 install -r requirements.txt > /dev/null 2>&1 && python3 setup.py install > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! LinkFinder installed."; echo "";
sleep 1.5
#SecretFinder
echo -e "\e[93m\e[1m----> Installing SecretFinder";
git clone https://github.com/m4ll0k/SecretFinder.git > /dev/null 2>&1;
cd SecretFinder
pip3 install -r requirements.txt > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! SecretFinder installed."; echo "";
sleep 1.5
#JSParser
echo -e "\e[93m\e[1m----> Installing JSParser";
git clone https://github.com/nahamsec/JSParser.git > /dev/null 2>&1;
cd JSParser*
sudo python setup.py install
cd ~/tools/
echo -e "\e[32mDone! JSParser installed."; echo "";
sleep 1.5

#---------Domain Flyover
#aquatone
echo -e "\e[93m\e[1m----> Installing Aquatone";
cd /tmp && wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip > /dev/null 2>&1 && unzip aquatone_linux_amd64_1.7.0.zip > /dev/null 2>&1;
mv aquatone /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Aquatone installed."; echo "";
sleep 1.5

#---------Crawling Web
#Gospider
echo -e "\e[93m\e[1m----> Installing Gospider";
go install github.com/jaeles-project/gospider@latest > /dev/null 2>&1 && ln -s ~/go/bin/gospider /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Gospider installed."; echo "";
sleep 1.5
#Hakrawler
echo -e "\e[93m\e[1m----> Installing Hakrawler";
go install github.com/hakluke/hakrawler@latest > /dev/null 2>&1 && ln -s ~/go/bin/hakrawler /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Hakrawler installed."; echo "";
sleep 1.5
#Katana
echo -e "\e[93m\e[1m----> Installing Katana";
go install github.com/projectdiscovery/katana/cmd/katana@latest > /dev/null 2>&1 && ln -s ~/go/bin/katana /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Katana installed."; echo "";
sleep 1.5

#---------Vuln XSS
#XSStrike
echo -e "\e[93m\e[1m----> Installing XSStrike";
git clone https://github.com/s0md3v/XSStrike > /dev/null 2>&1 && cd XSStrike && pip3 install -r requirements.txt > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! XSStrike installed."; echo "";
sleep 1.5
#XSS-Loader
echo -e "\e[93m\e[1m----> Installing XSS-Loader";
git clone https://github.com/capture0x/XSS-LOADER/ > /dev/null 2>&1 && cd XSS-LOADER && pip3 install -r requirements.txt > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! XSS-Loader installed."; echo "";
sleep 1.5
#Freq
echo -e "\e[93m\e[1m----> Installing Freq";
go install github.com/takshal/freq@latest > /dev/null 2>&1 && ln -s ~/go/bin/freq /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Freq installed."; echo "";
sleep 1.5
#Gxss
echo -e "\e[93m\e[1m----> Installing Gxss";
go install github.com/KathanP19/Gxss@latest > /dev/null 2>&1 && ln -s ~/go/bin/Gxss /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Gxss installed."; echo "";
sleep 1.5
#Dalfox
echo -e "\e[93m\e[1m----> Installing Dalfox";
go install github.com/hahwul/dalfox/v2@latest > /dev/null 2>&1 && ln -s ~/go/bin/dalfox /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Dalfox installed."; echo "";
sleep 1.5

#---------SSRF
#SSRFmap
echo -e "\e[93m\e[1m----> Installing SSRFmap";
git clone https://github.com/swisskyrepo/SSRFmap > /dev/null 2>&1 && cd SSRFmap && pip3 install -r requirements.txt > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! SSRFmap installed."; echo "";
sleep 1.5
#Gopherus
echo -e "\e[93m\e[1m----> Installing Gopherus";
git clone https://github.com/tarunkant/Gopherus.git > /dev/null 2>&1 && cd Gopherus && chmod +x install.sh && ./install.sh > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! Gopherus installed."; echo "";
sleep 1.5

#---------VulnScanners
#Nuclei
echo -e "\e[93m\e[1m----> Installing Nuclei";
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest > /dev/null 2>&1 && ln -s ~/go/bin/nuclei /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Nuclei installed."; echo "";
sleep 1.5

#---------VHOST Discover
#VirtualHostDiscovery
echo -e "\e[93m\e[1m----> Installing VirtualHostDiscovery";
git clone https://github.com/jobertabma/virtual-host-discovery.git  > /dev/null 2>&1;
cd ~/tools/
echo -e "\e[32mDone! VirtualHostDiscovery installed."; echo "";
sleep 1.5

#---------Misc.
#anew
echo -e "\e[93m\e[1m----> Installing Anew";
go install -v github.com/tomnomnom/anew@latest > /dev/null 2>&1 && ln -s ~/go/bin/anew /usr/local/bin/;
echo -e "\e[32mDone! Dnsgen installed."; echo "";
sleep 1.5
#unew
echo -e "\e[93m\e[1m----> Installing Unew";
go install -v github.com/dwisiswant0/unew@latest > /dev/null 2>&1 && ln -s ~/go/bin/unew /usr/local/bin/;
echo -e "\e[32mDone! Dnsgen installed."; echo "";
sleep 1.5
#gf
echo -e "\e[93m\e[1m----> Installing gf";
go install -v github.com/tomnomnom/gf@latest > /dev/null 2>&1 && ln -s ~/go/bin/gf /usr/local/bin/;
echo -e "\e[32mDone! Gf installed."; echo "";
sleep 1.5
#Http Probe
echo -e "\e[93m\e[1m----> Installing httprobe";
go install github.com/tomnomnom/httprobe@latest > /dev/null 2>&1 && ln -s ~/go/bin/httprobe /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Httprobe installed."; echo "";
sleep 1.5
#httpx
echo -e "\e[93m\e[1m----> Installing httpx";
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest > /dev/null 2>&1 && ln -s ~/go/bin/httpx /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Httpx installed."; echo "";
sleep 1.5
#waybackurls
echo -e "\e[93m\e[1m----> Installing waybackurls";
go install github.com/tomnomnom/waybackurls@latest > /dev/null 2>&1 && ln -s ~/go/bin/waybackurls /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Waybackurls installed."; echo "";
sleep 1.5
#Arjun
echo -e "\e[93m\e[1m----> Installing arjun";
pip3 install arjun > /dev/null 2>&1;
echo -e "\e[32mDone! Arjun installed."; echo "";
sleep 1.5
#Gau
echo -e "\e[93m\e[1m----> Installing gau";
go install github.com/lc/gau/v2/cmd/gau@latest > /dev/null 2>&1 && ln -s ~/go/bin/gau /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Gau installed."; echo "";
sleep 1.5
#Gauplus
echo -e "\e[93m\e[1m----> Installing gauplus";
go install github.com/bp0lr/gauplus@latest  > /dev/null 2>&1 && ln -s ~/go/bin/gauplus /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Gauplus installed."; echo "";
sleep 1.5
#Uro
echo -e "\e[93m\e[1m----> Installing uro";
pip3 install uro > /dev/null;
cd ~/tools/
echo -e "\e[32mDone! Uro installed."; echo "";
sleep 1.5
#QSreplace
echo -e "\e[93m\e[1m----> Installing qsreplace";
go get -v github.com/tomnomnom/qsreplace > /dev/null 2>&1 && ln -s ~/go/bin/qsreplace /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Qsreplace installed."; echo "";
sleep 1.5
sleep 1.5
#SocialHunter
echo -e "\e[93m\e[1m----> Installing Socialhunter";
go install github.com/utkusen/socialhunter@latest > /dev/null 2>&1 && ln -s ~/go/bin/socialhunter /usr/local/bin/;
cd ~/tools/
echo -e "\e[32mDone! Socialhunter installed."; echo "";
sleep 1.5

echo -e "\e[92mDone! Happy Hunting ;)\e[0m\e[39m"; echo "";