#!/bin/sh
#
# Remove o snap e instala o Firefox via apt e o Flatpak
#
# Author: Alcindo Gandhi
# Date: 2020-06-19
#


# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

# Removendo o Snap
snap remove firefox
snap remove gnome-3-38-2004
snap remove gtk-common-themes
snap remove snap-store
snap remove snapd-desktop-integration
snap remove software-boutique ubuntu-mate-welcome
snap remove bare
snap remove core20
snap remove snapd

apt-get -y autoremove --purge snapd

# Instalando o Firefox via APT
add-apt-repository ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | tee /etc/apt/preferences.d/mozilla-firefox
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' \
	| tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
apt-get -y install firefox-esr firefox-esr-locale-pt

# Instalando o Flatpak e a GNOME Software
apt-get -y --no-install-recommends install \
	flatpak gnome-software gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
