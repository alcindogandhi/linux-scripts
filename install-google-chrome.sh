#!/bin/sh
#
# Instalação do Google Chrome
#
# Nome: Alcindo Gandhi
# Data: 18/02/2023
#

DIR=$(pwd)
URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
FILE=$(basename $URL)

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

cd /tmp
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    echo "Falha no download do arquivo $FILE"
    rm -f $FILE
    cd $DIR
	exit 2
fi

apt install ./$FILE
if [ $? -ne 0 ]; then
    echo "Falha ao instalar o arquivo $FILE"
    rm -f /tmp/$FILE
    cd $DIR
	exit 3
fi

rm -f /tmp/$FILE
cd $DIR
