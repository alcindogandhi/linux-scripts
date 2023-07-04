#!/bin/sh

if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

OS_RELEASE="/etc/os-release"
VERSION_CODENAME=$(cat $OS_RELEASE | grep "^VERSION_CODENAME" | cut -d'=' -f2)
UBUNTU_CODENAME=$(cat $OS_RELEASE  | grep "^UBUNTU_CODENAME"  | cut -d'=' -f2)
CODENAME=${1:-$([ -z $UBUNTU_CODENAME ] && echo $VERSION_CODENAME || echo $UBUNTU_CODENAME)}
DISTRO=$([ -z $UBUNTU_CODENAME ] && echo "debian" || echo "ubuntu")

if [ $DISTRO = "debian" ]; then
    if [ $CODENAME = "bookworm" ]; then
        CODENAME="lunar"
    elif [ $CODENAME = "bullseye" ]; then
        CODENAME="focal"
    else
        NAME=$(grep "^PRETTY_NAME" /etc/os-release | cut -d'"' -f2)
        echo "Erro! $NAME não suportado."
    fi
fi

URL="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xfda854f61c4d0d9572bb95e5245d5502fad7a805"

wget -q -O- $URL | gpg --dearmor | tee /usr/share/keyrings/kicad-7.gpg 1>/dev/null 2>&1
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/kicad-7.gpg] https://ppa.launchpadcontent.net/kicad/kicad-7.0-releases/ubuntu/ $CODENAME main" \
    >/etc/apt/sources.list.d/kicad-7-$CODENAME.list

apt-get update
apt-get -y install kicad
