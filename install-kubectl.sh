#!/bin/sh
#
# Script para instalação do Kubectl
#
# Autor: Alcindo Gandhi
# Data: 17/02/2025
#

VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
URL="https://dl.k8s.io/release/$VERSION/bin/linux/amd64/kubectl"
CHKSUM_URL="https://dl.k8s.io/release/$VERSION/bin/linux/amd64/kubectl.sha256"
FILE=$(basename $URL)
CHKSUM_FILE=$(basename $CHKSUM_URL)

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

if [ -z "$VERSION" ]; then
    echo 1>&2
    echo "Erro! Falha na obtenção da versão do Kubectl para instalação." 1>&2
    echo 1>&2
    exit 2
fi

cd /tmp
rm -f $FILE
echo
printf "Efetuando o download do Kubectl nos servidores do Github ... "
wget -q $URL
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha no download do Kubectl $VERSION"
	echo >&2 "URL: $URL"
	echo >&2
	exit 3
fi

echo "Ok"
printf "Validando o arquvo baixado ... "
rm -f $CHKSUM_FILE
wget -q $CHKSUM_URL 
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha ao obter o arquivo de checksum do Kubectl $VERSION"
	echo >&2
	rm -f $FILE
	exit 4
fi
echo "$(cat $CHKSUM_FILE)  kubectl" | sha256sum --check >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Checksum do arquivo baixado do Kubectl $VERSION inválido"
	echo >&2
	rm -f $FILE $CHKSUM_FILE
	exit 5
fi
rm -f $CHKSUM_FILE

echo "Ok"
printf "Instalando o programa ... "
install -o root -g root -m 0755 $FILE /usr/local/bin/$FILE
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha ao instalar o arquivo do Kubectl $VERSION"
	echo >&2
	rm -fr $FILE
	exit 6
fi
rm -f /tmp/$FILE

echo "Ok"
echo
echo "Kubectl $VERSION instalado com sucesso."
echo

