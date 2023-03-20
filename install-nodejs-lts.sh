#!/bin/sh
#
# Instalação do Eclipse JEE
#
# Nome: Alcindo Gandhi
# Data: 24/02/2023
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

tidy --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    REQUIREMENTS="$REQUIREMENTS tidy"
fi

if [ -n "$REQUIREMENTS" ]; then
    apt-get -y install $REQUIREMENTS
    if [ $? -ne 0 ]; then
        echo "Falha na instalação dos requisitos para execução do script."
        exit 2
    fi
fi

DIR=$(pwd)
URL=$(curl -s https://nodejs.org/en/download | tidy 2>/dev/null | grep linux-x64 | cut -d'"' -f2)
FILE=$(basename $URL)
VERSION=$(echo $FILE | cut -d'-' -f2)

cd /opt
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    echo "Falha no download do arquivo $FILE"
    rm -f $FILE
    cd $DIR
	exit 3
fi

tar -xJf $FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f $FILE
    cd $DIR
	exit 3
fi

rm -fr node node-$VERSION $FILE
mv "node-$VERSION-linux-x64" "node-$VERSION"
ln -s node-$VERSION node

cd $DIR
echo
echo "Instalação do NodeJS $VERSION efetuada com sucesso"
echo
