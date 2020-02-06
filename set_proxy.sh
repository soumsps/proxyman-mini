#!/bin/bash

source "./variables.sh"
source "./configs.sh"


echo ""
echo "${bold}Setting IET Proxy${normal}"
echo ""

echo "${yellow}Proxy config to be set :${normal}"
echo "http => $http_host:$http_port"
echo "https => $https_host:$https_port"
echo "ftp => $ftp_host:$ftp_port"
echo "socks => $socks_host:$socks_port"
echo ""
echo "${cyan}------------------------------------${normal}"
echo ""




set_proxy_gsettings(){
    echo "${bold}${red}Setting proxy for GNOME User Interface ${normal}"
    # setting gsetting proxy
    gsettings set org.gnome.system.proxy mode "manual"
    gsettings set org.gnome.system.proxy.http host "$http_host"
    gsettings set org.gnome.system.proxy.http port "$http_port"
    gsettings set org.gnome.system.proxy.https host "$https_host"
    gsettings set org.gnome.system.proxy.https port "$https_port"
    gsettings set org.gnome.system.proxy.ftp host "$ftp_host"
    gsettings set org.gnome.system.proxy.ftp port "$ftp_port"
    gsettings set org.gnome.system.proxy.socks host "$socks_host"
    gsettings set org.gnome.system.proxy.socks port "$socks_port"
    gsettings set org.gnome.system.proxy.http authentication-password "$password"
    gsettings set org.gnome.system.proxy.http authentication-user "$username"

    if [ "$use_auth" = "YES" ]; then
        gsettings set org.gnome.system.proxy.http use-authentication true
    else
        gsettings set org.gnome.system.proxy.http use-authentication false
    fi
}






set_proxy_apt(){
    echo "${bold}${red}Setting proxy for APT and linux terminal ${normal}"
    CONF_FILE='/etc/apt/apt.conf.d/proxy.conf'

    if [ -e $CONF_FILE ]; then
        echo "proxy.conf file exist, and now it will be deleted"
        sudo unlink /etc/apt/apt.conf.d/proxy.conf
    else
        echo "proxy.conf file does not exist"
    fi

    

    if [ ! -e $CONF_FILE ]; then
        echo "proxy.conf file does not exist, so creating it"
        sudo touch $CONF_FILE
    fi

    local stmt=""
    if [ "$use_auth" = "YES" ]; then
        stmt="${username}:${password}@"
    fi


    echo "Acquire::Http::Proxy \"http://${stmt}${http_host}:${http_port}\";" | sudo tee -a $CONF_FILE

    echo "Acquire::Https::Proxy \"https://${stmt}${https_host}:${https_port}\";" | sudo tee -a $CONF_FILE
    
    echo "Acquire::Ftp::Proxy \"ftp://${stmt}${ftp_host}:${ftp_port}\";" | sudo tee -a $CONF_FILE
}


set_proxy_git(){
    echo "${bold}${red}Setting proxy for git ${normal}"

    local stmt=""
    if [ "$use_auth" = "YES" ]; then
        stmt="${username}:${password}@"
    fi

    git config --global http.proxy "http://${stmt}${http_host}:${http_port}/"
    git config --global https.proxy "https://${stmt}${https_host}:${https_port}/"
}



set_proxy_npm() {
    local stmt=""
    if [ "$use_auth" = "yes" ]; then
        stmt="${username}:${password}@"
    fi

    npm config set proxy "http://${stmt}${http_host}:${http_port}/"

    npm config set https-proxy "https://${stmt}${https_host}:${https_port}/"
    
}



#function calling
set_proxy_gsettings
set_proxy_apt
#set_proxy_git
#set_proxy_npm