#!/bin/bash

source "./variables.sh"
source "./configs.sh"


echo ""
echo "${bold}Removing Proxy Settings${normal}"
echo ""

echo "${yellow}Proxy config to be removed :${normal}"
echo "http => $http_host:$http_port"
echo "https => $https_host:$https_port"
echo "ftp => $ftp_host:$ftp_port"
echo "socks => $socks_host:$socks_port"
echo ""
echo "${cyan}------------------------------------${normal}"
echo ""

unset_proxy_gsettings(){
    echo "${bold}${red}Removing proxy for GNOME User Interface ${normal}"

    # removing gsetting proxy
    gsettings set org.gnome.system.proxy mode none
}


unset_proxy_apt(){
    echo "${bold}${red}Removing proxy for APT and linux terminal ${normal}"
    CONF_FILE='/etc/apt/apt.conf.d/proxy.conf'

    if [ -e $CONF_FILE ]; then
        echo "proxy.conf file exist, and now it will be deleted"
        sudo unlink /etc/apt/apt.conf.d/proxy.conf
    else
        echo "proxy.conf file does not exist"
    fi
    
}


unset_proxy_git(){
    echo "${bold}${red}Removing proxy for Git ${normal}"
    git config --global --unset http.proxy
    git config --global --unset https.proxy
}

unset_proxy_npm() {
    npm config delete proxy
    npm config delete https-proxy
}



#function calling

unset_proxy_gsettings
unset_proxy_apt
#unset_proxy_git
#unset_proxy_npm