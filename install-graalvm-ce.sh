#!/bin/sh
#
# Instalação da JDK Graal VM
#
# Nome: Alcindo Gandhi
# Data: 23/04/2025
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

# Instalando os requisitos do script
wget --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro!"
    echo "Para a correta execução deste script, é necessário o programa \"wget\""
    exit 2
fi

curl --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro!"
    echo "Para a correta execução deste script, é necessário o programa \"curl\""
    exit 3
fi

VERSION=$1
if [ -z "$VERSION" ]; then
    URL=$(curl -s https://github.com/graalvm/graalvm-ce-builds/releases | grep "linux-x64_bin.tar.gz" | head -1 | cut -d'"' -f4)
else
    URL=$(curl -s https://github.com/graalvm/graalvm-ce-builds/releases | grep "linux-x64_bin.tar.gz" | grep "$VERSION" | head -1 | cut -d'"' -f4)
fi

if [ -z "$URL" ]; then
    echo "Erro! URL gerada para download do GraalVM inválida."
    exit 4
fi

VERSION=$(echo $URL | cut -d'/' -f8 | cut -d'-' -f2)
MAJOR_VERSION=$(echo $VERSION | cut -d'.' -f1)
FILE=$(basename $URL)

cd /opt
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    echo "Falha no download do arquivo $FILE"
    rm -f $FILE
	exit 5
fi

rm -fr "graalvm-community-openjdk-$VERSION"*
tar -xzf $FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f $FILE
	exit 6
fi
rm -f $FILE
DIR=$(ls -d "graalvm-community-openjdk-$VERSION"* | head -1)

rm -f "graalvm-$MAJOR_VERSION" "graalvm"
ln -s "$DIR" "graalvm-$MAJOR_VERSION"
ln -s "graalvm-$MAJOR_VERSION" "graalvm"

echo
echo "Instalação do GraalVM CE $VERSION concluída com sucesso."
echo
