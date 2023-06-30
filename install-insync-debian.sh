#!/bin/sh

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

DISTRIBUTION=$(grep "^ID" /etc/os-release | cut -d'=' -f2)
CODENAME=$(grep "^VERSION_CODENAME" /etc/os-release | cut -d'=' -f2)

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C

echo "deb http://apt.insync.io/$DISTRIBUTION $CODENAME non-free contrib"\
    >/etc/apt/sources.list.d/insync.list

apt-get update
apt-get -y install insync

if [ $? -ne 0 ]; then
    echo
    echo "Erro! Falha na instalação do Insync."
    echo
	exit 2
fi

echo
echo "Insync instalado com sucesso."
echo