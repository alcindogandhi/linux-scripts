#!/bin/sh
#
# File: install-youtube-dl.sh
#
# Install the latest release of youtube-dl file from GitHub repository
# See: https://github.com/ytdl-org/youtube-dl
#
# Author: Alcindo Gandhi
# Date: 2020-03-22
#

TAG=$(curl -s https://github.com/ytdl-org/ytdl-nightly/releases | grep 'releases/tag' | head -1 | cut -d'"' -f6 | cut -d'/' -f6)
URL="https://github.com/ytdl-org/ytdl-nightly/releases/download/$TAG/youtube-dl"
DEST=/usr/local/bin

if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

sudo mkdir -p $DEST
sudo wget -q -N $URL -O $DEST/youtube-dl
if [ $? -ne 0 ]; then
    echo "Falha no download do youtube-dl $TAG"
    rm -f $FILE
	exit 2
fi

sudo sed -i '1 s/python/python3/' $DEST/youtube-dl
sudo chmod +x $DEST/youtube-dl

VERSION=$($DEST/youtube-dl --version)
echo
echo "youtube-dl $VERSION"
echo
