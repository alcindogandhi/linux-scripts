#!/bin/sh
#
# Script para instalação do Teams no Debian.
#
# Fonte: https://github.com/IsmaelMartinez/teams-for-linux
#
# Autor: Alcindo Gandhi
# Data: 21/05/2024
#

DIR="/etc/apt/keyrings"
KEY="$DIR/teams-for-linux.asc"
KEY_URL="https://repo.teamsforlinux.de/teams-for-linux.asc"
ARCH=$(dpkg --print-architecture)
DEB="deb [signed-by=$KEY arch=$ARCH] https://repo.teamsforlinux.de/debian/ stable main"

if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

mkdir -p $DIR
wget -qO $KEY $KEY_URL
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha no download da chave do repositório do Teams."
	echo >&2
	exit 1
fi

echo $DEB | tee /etc/apt/sources.list.d/teams-for-linux.list

apt update
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha na atualização da lista de pacotes do sistema."
	echo >&2
	exit 2
fi

apt -y install teams-for-linux
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha na instalação do Teams."
	echo >&2
	exit 1
fi

echo
echo "Teams for Linux instalado com sucesso."
echo
