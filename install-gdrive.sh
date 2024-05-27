#!/bin/sh
#
# Script para download da última versão do GDrive
#
# Autor: Alcindo Gandhi
# Data: 27/05/2024
#

GIT_URL="https://github.com/glotlabs/gdrive/releases"
VERSION=$(curl -s $GIT_URL | grep '<h2 class="sr-only"' | head -2 | tail -1 | cut -d'>' -f2 | cut -d'<' -f1 | cut -d'v' -f2)
URL=https://github.com/glotlabs/gdrive/releases/download/$VERSION/gdrive_linux-x64.tar.gz
FILE=$(basename $URL)

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

cd /tmp
rm -f $FILE
printf "Efetuando o download do GDrive nos servidores do Github ... "
wget -q $URL
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha no download do GDrive $VERSION"
	echo >&2 "URL: $URL"
	echo >&2
	exit 2
fi

echo "Ok"
printf "Instalando o programa ... "
cd /usr/local/bin
rm -fr gdrive
tar -xzf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha ao descompactar o arquivo do GDrive $VERSION"
	echo >&2
	rm -fr $FILE /tmp/$FILE
	exit 2
fi
rm -f /tmp/$FILE

echo "Ok"
echo
echo "GDrive $VERSION instalado com sucesso."
echo
