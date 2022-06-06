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

URL=https://yt-dl.org/downloads/latest/youtube-dl
DEST=/usr/local/bin

sudo mkdir -p $DEST
sudo wget -q -N $URL -O $DEST/youtube-dl
sudo sed -i '1 s/python/python3/' $DEST/youtube-dl
sudo chmod +x $DEST/youtube-dl

VERSION=$($DEST/youtube-dl --version)
echo "youtube-dl $VERSION"
echo

