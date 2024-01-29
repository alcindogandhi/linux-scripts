#!/bin/sh
#
# Instalação do Arduino CLI
#
# Nome: Alcindo Gandhi
# Data: 11/05/2023
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

VERSION=$(curl -s https://github.com/arduino/arduino-cli/releases/ | grep "sr-only" | grep "h2" | head -1 | cut -d'>' -f2 | cut -d'<' -f1 | cut -d'v' -f2)
FILE="arduino-cli_${VERSION}_Linux_64bit.tar.gz"
URL="https://github.com/arduino/arduino-cli/releases/download/v$VERSION/$FILE"

# Baixando o Arduino CLI do repositório
echo "### Efetuando o download do Arduino CLI $VERSION ###"
cd /tmp
ls $FILE >/dev/null 2>&1
if [ $? -ne 0 ]; then
    wget $URL -O $FILE
    if [ $? -ne 0 ]; then
        echo "Falha no download do arquivo $FILE"
        rm -f $FILE
        exit 3
    fi
fi

echo "### Descompactando o arquivo baixando ###"
rm -fr $ARDUINO_CLI
tar -xzf $FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f $FILE
	exit 3
fi
rm -fr $FILE /usr/local/bin/arduino-cli
mv arduino-cli /usr/local/bin

echo
echo "### Instalação do Arduino CLI $VERSION efetuada com sucesso. ###"
echo
