#!/bin/sh
#
# Script de instalação do VSCode
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2023-09-22
#
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

URL='https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
DEB='code.deb'

wget $URL -O $DEB
if [ $? -ne 0 ]; then
    rm -f $DEB
	echo >&2
	echo >&2 "Erro! Falha no download do Visual Studio Code."
	echo >&2
	exit 2
fi

sudo apt-get update
sudo apt-get -y install ./$DEB
if [ $? -ne 0 ]; then
    rm -f $DEB
	echo >&2
	echo >&2 "Erro! Falha na instalação do Visual Studio Code."
	echo >&2
	exit 3
fi

rm $DEB
echo
echo "Instalação do Visual Studio Code concluída com sucesso."
echo
