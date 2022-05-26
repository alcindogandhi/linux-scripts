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

VERSION=$(curl -sv https://github.com/telegramdesktop/tdesktop/releases/latest 2>&1 \
    | grep location: | cut -d/ -f8 | cut -dv -f2 | tr -d '\r\n')
FILE="tsetup.$VERSION.tar.xz"
URL="https://updates.tdesktop.com/tlinux/$FILE"
DIR=$(pwd)

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
sudo rm -fr telegram-$VERSION
sudo tar -xJf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha na descompactação do arquivo do Telegram"
	echo >&2
    rm -fr /tmp/$FILE
    cd $DIR
	exit 1
fi

sudo mv Telegram telegram-$VERSION
sudo rm -f telegram /usr/share/applications/telegram.desktop
sudo ln -s telegram-$VERSION telegram
cd telegram
sudo mv Telegram telegram
sudo mv Updater updater

cat <<EOF >telegram.desktop
[Desktop Entry]
Version=1.5
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
Exec=/opt/telegram/telegram -- %u
Icon=telegram
Terminal=false
StartupWMClass=TelegramDesktop
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
