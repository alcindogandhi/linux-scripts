#!/bin/sh
#
# Instalação do Arduino v1.8
#
# Nome: Alcindo Gandhi
# Data: 18/02/2024
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

# Instalando os requisitos do script em sistemas Debian
apt-get --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    apt-get -y install wget curl python3-serial
fi

# Verificando os requisitos do script
wget --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Erro! Instale o "wget" no sistema antes de continuar.'
    exit 2
fi

curl --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Erro! Instale o "curl" no sistema antes de continuar.'
    exit 3
fi

VERSION=$(curl -s https://github.com/arduino/Arduino/releases | grep "/arduino/Arduino/tree/" | head -1 | cut -d'"' -f2 | cut -d'/' -f5)
FILE="arduino-${VERSION}-linux64.tar.xz"
URL="https://downloads.arduino.cc/${FILE}"

# Baixando o Arduino do repositório
echo
echo "### Efetuando o download do Arduino $VERSION ###"
cd /tmp
ls $FILE >/dev/null 2>&1
if [ $? -ne 0 ]; then
    wget $URL -O $FILE
    if [ $? -ne 0 ]; then
        echo "Falha no download do arquivo $FILE"
        rm -f $FILE
        exit 4
    fi
fi

echo
echo "### Descompactando o arquivo baixando ###"
cd /opt
tar -xJf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f /tmp/$FILE
	exit 5
fi
rm -fr arduino /tmp/$FILE /usr/local/bin/arduino
ln -s "arduino-${VERSION}" arduino
cd arduino
sh install.sh

echo
echo "### Instalação do Arduino $VERSION efetuada com sucesso. ###"
echo
