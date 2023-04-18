#!/bin/sh
#
# Script para configuração de uma VM com LXDE/Debian
#
# Autor: Alcindo Gandhi
# Data: 25/03/2023
#

if [ "$(id -u)" != "0" ]; then
	echo "Este script deve ser executado como root." 1>&2
	exit 1
fi

USUARIO=$(grep ":1000:" /etc/group | cut -d':' -f1)
DIR=$(pwd)
PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin

cat <<EOF >/etc/apt/sources.list
deb http://ftp.br.debian.org/debian/ bullseye main cotrib non-free
deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb http://ftp.br.debian.org/debian/ bullseye-updates main contrib non-free
EOF

apt-get update
apt-get -y dist-upgrade
apt-get -y install build-essential linux-headers-amd64 vim scite meld git wget curl sed

mount -o ro /media/cdrom
cd /media/cdrom
sh VBoxLinuxAdditions.run
/sbin/addgroup $USUARIO vboxsf
/sbin/addgroup $USUARIO sudo
cd /media
umount cdrom

sed -i "s/#autologin-user=/autologin-user=$USUARIO/" /etc/lightdm/lightdm.conf
sed -i "s/#autologin-user-timeout=0/autologin-user-timeout=0/" /etc/lightdm/lightdm.conf
sed -i "s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/" /etc/default/grub
update-grub

cd $DIR
echo
echo "Configuração do sistema realizada com sucesso."
echo "Reinicie o sistema para concluir as modficações."
echo
