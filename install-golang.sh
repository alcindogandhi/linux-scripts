#!/bin/sh
#
# Instalação do Golang
#
# Nome: Alcindo Gandhi
# Data: 01/12/2025
#

DIR=$(pwd)
URL=$(curl -s https://go.dev/dl/ | grep "linux-amd64.tar.gz" | head -1 | cut -d'"' -f4)
URL="https://go.dev$URL"
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

cd /opt
rm -fr go
tar -xzf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo "Falha ao extrair o arquivo $FILE"
    rm -f /tmp/$FILE
    cd $DIR
    exit 3
fi
rm -f /tmp/$FILE
cd $DIR

# Configura variáveis de ambiente
if ! grep -q 'export PATH=$PATH:/opt/go/bin' /etc/profile; then
    echo 'export PATH=$PATH:/opt/go/bin' >> /etc/profile
    export PATH=$PATH:/opt/go/bin
fi

echo "Golang instalado com sucesso!"
/opt/go/bin/go version
