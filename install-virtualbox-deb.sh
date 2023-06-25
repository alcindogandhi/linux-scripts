#!/bin/sh
#
# Script de instalação do Oracle Virtualbox em distribuicoes DEB
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2022-06-02
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

cd /tmp


OS_RELEASE="/etc/os-release"
VERSION_CODENAME=$(cat $OS_RELEASE | grep "^VERSION_CODENAME" | cut -d'=' -f2)
UBUNTU_CODENAME=$(cat $OS_RELEASE  | grep "^UBUNTU_CODENAME"  | cut -d'=' -f2)
CODENAME=${1:-$([ -z $UBUNTU_CODENAME ] && echo $VERSION_CODENAME || echo $UBUNTU_CODENAME)}
URL=$(curl -s https://www.virtualbox.org/wiki/Linux_Downloads | grep $CODENAME | cut -d'"' -f4 | head -1)

# Se não encontrar a URL, usar como padrão o Ubuntu 22.04 Jammy
if [ -z $URL ]; then
    CODENAME="jammy"
    URL=$(curl -s https://www.virtualbox.org/wiki/Linux_Downloads | grep $CODENAME | cut -d'"' -f4 | head -1)
fi

VERSION=$(echo $URL | cut -d'/' -f5)
VB_PACKAGE=$(echo $URL | cut -d'/' -f6)
EP_PACKAGE="Oracle_VM_VirtualBox_Extension_Pack-$VERSION.vbox-extpack"

printf "Efetuando o download do Oracle Virtualbox $VERSION ... "
wget -qO $VB_PACKAGE $URL
if [ $? -ne 0 ]; then
	rm -fr $VB_PACKAGE
	echo "NOK"
	echo >&2
	echo >&2 "Erro! Falha no download do Oracle Virtualbox $VERSION"
	echo >&2
	exit 1
fi
echo "OK"
echo
printf "Efetuando o download do Oracle Extension Pack $VERSION ... "
wget -qO $EP_PACKAGE "https://download.virtualbox.org/virtualbox/$VERSION/$EP_PACKAGE"
if [ $? -ne 0 ]; then
	rm -fr $EP_PACKAGE
	echo "NOK"
	echo >&2
	echo >&2 "Erro! Falha no download do Extension Pack $VERSION"
	echo >&2
	exit 2
fi
echo "OK"
echo
echo "Instalando os pacotes ..."
echo
apt -y install ./$VB_PACKAGE
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha na instalação do Oracle Virtualbox $VERSION."
	echo >&2
    rm -fr $VB_PACKAGE $EP_PACKAGE
	exit 3
fi

VBoxManage extpack install --replace $EP_PACKAGE
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha na instalação do Extension Pack $VERSION."
	echo >&2
    rm -fr $VB_PACKAGE $EP_PACKAGE
	exit 3
fi
rm -fr $VB_PACKAGE $EP_PACKAGE

VBUSER=$(cat /etc/passwd | grep "x:1000" | cut -d':' -f1)
usermod -aG vboxusers $VBUSER
usermod -aG vboxsf $VBUSER

echo
echo "Instalação do Oracle Virtualbox $VERSION concluida com sucesso."
echo
