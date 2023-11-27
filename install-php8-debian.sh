#!/bin/sh
#
# Instalação da última versão do PHP no Debian/Ubuntu
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2022-04-15
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

# Instala os repositórios para o Ubuntu (e derivados) ou Debian
UBUNTU_CODENAME=$(cat /etc/os-release  | grep "^UBUNTU_CODENAME"  | cut -d'=' -f2)
if [ -n "$UBUNTU_CODENAME" ]; then
    add-apt-repository ppa:ondrej/php
else
    apt-get -y install lsb-release apt-transport-https ca-certificates
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
fi

apt-get update
apt-get -y dist-upgrade

PHP=`apt-cache search php8.* | grep "metapackage" | sort | tail -1 | cut -d" " -f1`

apt-get --no-install-recommends -y install $PHP $PHP-xml $PHP-mbstring $PHP-curl

php -v

