#!/bin/sh
#
# File: install-telegram.sh
#
# Install the latest release of Telegram-Desktop from GitHub repository
# See: https://github.com/telegramdesktop/tdesktop
#
# Author: Alcindo Gandhi
# Date:   2022-05-26
#

VERSION=$(curl -s https://github.com/telegramdesktop/tdesktop/releases | \
	grep "<li data-item-id" | head -1 | cut -d'"' -f2 | cut -d'-' -f2 | cut -d'v' -f2)
FILE="td-setup-linux-x64-$VERSION.tar.xz"
URL="https://github.com/telegramdesktop/tdesktop/releases/download/v$VERSION/$FILE"
DIR=$(pwd)

LOCAL_VERSION=$(cat /opt/telegram/version)
if [ "$VERSION" = "$LOCAL_VERSION" ]; then
	echo "A versão local do Telegram $VERSION já está atualizada."
	exit 0
fi

cd /tmp
sudo rm -f $FILE
wget $URL
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha no download do Telegram"
	echo >&2
    cd $DIR
	exit 1
fi

cd /opt
sudo rm -fr telegram
sudo tar -xJf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha na descompactação do arquivo do Telegram"
	echo >&2
    rm -fr /tmp/$FILE
    cd $DIR
	exit 1
fi

sudo mv Telegram telegram
sudo rm -f /usr/share/applications/telegram.desktop
cd telegram
sudo mv Telegram telegram
sudo mv Updater updater
echo "$VERSION" >version

cat <<EOF >telegram.desktop
[Desktop Entry]
Version=1.5
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
Exec=/opt/telegram/telegram -- %u
Icon=org.telegram.desktop
Terminal=false
StartupWMClass=Telegram
Type=Application
Categories=Chat;Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/tg;
Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
Actions=Quit;
SingleMainWindow=true
X-GNOME-UsesNotifications=true
X-GNOME-SingleWindow=true

[Desktop Action Quit]
Exec=telegram-desktop -quit
Name=Quit Telegram
Icon=application-exit
EOF

cd /usr/share/applications
sudo ln -s /opt/telegram/telegram.desktop

cd $DIR

echo "Telegram v$VERSION instalado com sucesso."
echo
