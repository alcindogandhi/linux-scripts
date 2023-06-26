#!/bin/sh
#
# Instalação do MySQL Workbench no Ubuntu
#
# Nome: Alcindo Gandhi
# Data: 28/02/2023
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

# Instalando os requisitos do script
REQUIREMENTS=""
wget --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    REQUIREMENTS="$REQUIREMENTS wget"
fi

curl --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    REQUIREMENTS="$REQUIREMENTS curl"
fi

if [ -n "$REQUIREMENTS" ]; then
    apt-get -y install $REQUIREMENTS
    if [ $? -ne 0 ]; then
        echo "Falha na instalação dos requisitos para execução do script."
        exit 2
    fi
fi

install_debian_12() {
    rm -fr /tmp/install-mysql-workbench
    mkdir /tmp/install-mysql-workbench
    cd /tmp/install-mysql-workbench
    wget "https://downloads.mysql.com/archives/get/p/8/file/mysql-workbench-community_8.0.20-1ubuntu18.04_amd64.deb"
    wget "http://security.ubuntu.com/ubuntu/pool/main/m/mysql-8.0/libmysqlclient21_8.0.33-0ubuntu0.23.04.2_amd64.deb"
    wget "http://mirrors.kernel.org/ubuntu/pool/main/libj/libjpeg8-empty/libjpeg8_8c-2ubuntu11_amd64.deb"
    wget "http://mirrors.kernel.org/ubuntu/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_2.1.5-2ubuntu1_amd64.deb"
    wget "http://mirrors.kernel.org/ubuntu/pool/main/g/glibmm2.4/libglibmm-2.4-1v5_2.66.6-1_amd64.deb"
    apt-get -f install "./*.deb"
    cd ~
    rm -fr /tmp/install-mysql-workbench
    echo
    echo "Instalação do MySQL Workbench $VERSION concluída com sucesso."
    echo
}


ID=$(cat /etc/os-release | grep "^ID=" | cut -d'=' -f2)
if [ $ID = "debian" ]; then
    VERSION=$(grep "^VERSION_ID" /etc/os-release | cut -d'"' -f2)
    if [ $VERSION -lt 12 ]; then
        install_debian_12()
        exit 0
    else
        RELEASE="22.04"
        VERSION=$(curl -s https://dev.mysql.com/downloads/workbench/ | grep "h1" | cut -d'>' -f2 | cut -d' ' -f3)
        URL="https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_${VERSION}-1ubuntu${RELEASE}_amd64.deb"
    fi
else
    if [ $ID = "ubuntu" ]; then
        UBUNTU_RELEASE=$(cat /etc/lsb-release  | grep RELEASE | cut -d'=' -f2)
    else
        UBUNTU_RELEASE=$(cat /etc/upstream-release/lsb-release  | grep RELEASE | cut -d'=' -f2)
    fi
    VERSION=$(curl -s https://dev.mysql.com/downloads/workbench/ | grep "h1" | cut -d'>' -f2 | cut -d' ' -f3)
    URL="https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_${VERSION}-1ubuntu${UBUNTU_RELEASE}_amd64.deb"
fi
FILE=$(basename $URL)

cd /tmp
echo "Fazendo o download do arquivo $URL ..."
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    echo "Falha no download do arquivo $FILE"
    rm -f $FILE
	exit 3
fi

apt-get -y install ./$FILE
if [ $? -ne 0 ]; then
    echo "Falha ao instalar o arquivo $FILE"
    rm -f $FILE
	exit 4
fi

rm -f $FILE
echo
echo "Instalação do MySQL Workbench $VERSION concluída com sucesso."
echo
