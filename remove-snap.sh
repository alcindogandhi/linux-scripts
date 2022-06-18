#!/bin/sh
#
# Remove o snap e instala o Firefox via apt e o Flatpak
#

# Removendo o Snap
sudo snap remove firefox
sudo snap remove gnome-3-38-2004
sudo snap remove gtk-common-themes
sudo snap remove snap-store
sudo snap remove snapd-desktop-integration
sudo snap remove bare
sudo snap remove core20
sudo snap remove snapd

sudo apt-get -y autoremove --purge snapd

# Instalando o Firefox via APT
sudo add-apt-repository ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' \
	| sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
sudo apt-get -y install firefox

# Instalando o Flatpak e a GNOME Software
sudo apt-get -y --no-install-recommends install \
	flatpak gnome-software gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

