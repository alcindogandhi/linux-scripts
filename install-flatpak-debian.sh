#!/bin/sh
#
# Instala o Flatpak no Debian
#
# Author: Alcindo Gandhi
# Date: 2026-06-09
#


# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
	echo "Erro! Este script deve ser executado como root." 1>&2
	exit 1
fi

# Instalando o Flatpak e a GNOME Software
apt-get update
if [ "$?" -ne "0" ]; then
	echo "Erro! Falha na atualização do repositório de pacotes." 1>&2
	exit 2
fi

apt-get -y --no-install-recommends install \
	flatpak gnome-software gnome-software-plugin-flatpak
if [ "$?" -ne "0" ]; then
	echo "Erro! Falha na instalação do Flatpak." 1>&2
	exit 3
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
if [ "$?" -ne "0" ]; then
	echo "Erro! Falha na adição do Flathub na lista de repositórios do Flatpak." 1>&2
	exit 4
fi

echo
echo "Flatpak instalado e configurado com sucesso."
echo

