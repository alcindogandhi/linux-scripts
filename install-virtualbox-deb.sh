#!/bin/sh
#
# Script de instalação do Oracle Virtualbox em distribuicoes DEB
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2022-06-02
#

CODENAME=${1:-$(lsb_release -c | awk '{print $2}')}
URL=$(curl -s https://www.virtualbox.org/wiki/Linux_Downloads | grep $CODENAME | cut -d'"' -f4)
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
sudo apt -y install ./$VB_PACKAGE
sudo VBoxManage extpack install --replace $EP_PACKAGE
rm -fr $VB_PACKAGE $EP_PACKAGE

echo
echo "Instalação do Oracle Virtualbox $VERSION concluida com sucesso."
echo

