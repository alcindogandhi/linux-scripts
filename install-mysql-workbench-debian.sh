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
    mkdir -p /tmp/install-mysql-workbench
    cd /tmp/install-mysql-workbench
    URLS="https://packages.ubuntu.com/lunar/amd64/libmysqlclient21/download"
	URLS="$URLS https://packages.ubuntu.com/lunar/amd64/libjpeg8/download"
    URLS="$URLS https://packages.ubuntu.com/lunar/amd64/libjpeg-turbo8/download"
    URLS="$URLS https://packages.ubuntu.com/lunar/amd64/libglibmm-2.4-1v5/download"

    for url in ${URLS};
    do
        url=$(curl -s $url | grep ".deb" | grep "http" | head -1 | cut -d'"' -f2)
        echo "Fazendo o download do arquivo $url ..."
        wget $url
        if [ $? -ne 0 ]; then
            FILE=$(basename $url)
            echo "Falha no download do arquivo $FILE"
            cd /tmp && rm -fr /tmp/install-mysql-workbench
            exit 3
        fi
    done
}


ID=$(cat /etc/os-release | grep "^ID=" | cut -d'=' -f2)
if [ $ID = "debian" ]; then
    VERSION=$(grep "^VERSION_ID" /etc/os-release | cut -d'"' -f2)
    if [ $VERSION -lt 12 ]; then
        URL="https://downloads.mysql.com/archives/get/p/8/file/mysql-workbench-community_8.0.20-1ubuntu18.04_amd64.deb"
    else
        install_debian_12
        result=$?
        if [ $result -ne 0 ]; then
            exit result
        fi
        RELEASE="23.04"
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

mkdir -p /tmp/install-mysql-workbench
cd /tmp/install-mysql-workbench
echo "Fazendo o download do arquivo $URL ..."
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    echo "Erro! Falha no download do arquivo $FILE"
    cd /tmp && rm -fr /tmp/install-mysql-workbench
	exit 4
fi

apt-get -y install ./*.deb
if [ $? -ne 0 ]; then
    echo "Erro! Falha ao instalar os pacotes DEB."
    cd /tmp && rm -fr /tmp/install-mysql-workbench
	exit 5
fi

cd /tmp && rm -fr /tmp/install-mysql-workbench
echo
echo "Instalação do MySQL Workbench $VERSION concluída com sucesso."
echo

