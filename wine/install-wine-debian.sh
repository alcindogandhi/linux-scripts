#!/bin/sh
#
# Instalação e configuração do Wine no Debian 11
#
# Autor: Alcindo Gandhi
# Data:  17/04/2023
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

cat <<EOF >/etc/apt/sources.list
deb http://ftp.br.debian.org/debian bullseye main contrib non-free
deb http://ftp.br.debian.org/debian-security/ bullseye-security main contrib non-free
deb http://ftp.br.debian.org/debian bullseye-updates main contrib non-free
EOF

dpkg --add-architecture i386
apt-get update
apt-get -y dist-upgrade

echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer
fc-cache -f -v
apt-get -y install sudo wget curl nano vim ca-certificates scite
apt-get -y install --install-recommends wine wine32 wine64
mkdir /usr/share/wine/mono /usr/share/wine/gecko
wget -O - https://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-bin-4.9.4.tar.gz | tar -xzv -C /usr/share/wine/mono
wget -O /usr/share/wine/gecko/wine-gecko-2.47.1-x86.msi https://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi
wget -O /usr/share/wine/gecko/wine-gecko-2.47.1-x86_64.msi https://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86_64.msi
