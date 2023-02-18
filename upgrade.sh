#!/bin/sh
#
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

apt-get update
if [ $? -ne 0 ]; then
    echo "Falha na atualização do repositório."
	exit 2
fi

apt-get -dy dist-upgrade
if [ $? -ne 0 ]; then
    echo "Falha no download dos pacotes."
	exit 3
fi

apt-get -y dist-upgrade
if [ $? -ne 0 ]; then
    echo "Falha na atualização dos pacotes."
	exit 4
fi

apt-get -y autoremove

echo
echo "Atualizacao efetuada com sucesso."
echo
