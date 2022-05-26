#!/bin/sh
#
# Instalação do docker-compose
#

VERSION=${1:-$(curl -sv https://github.com/docker/compose/releases/latest 2>&1 \
    | grep location: | cut -d/ -f8 | tr -d '\r\n')}

URL="https://github.com/docker/compose/releases/download/$VERSION/docker-compose-$(uname -s)-$(uname -m)"
    
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -L $URL \
	-o /usr/local/lib/docker/cli-plugins/docker-compose
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha no download do docker-compose"
	echo >&2
	exit 1
fi

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo ln -sf /usr/local/lib/docker/cli-plugins/docker-compose \
	/usr/local/bin/docker-compose

echo
docker-compose --version
echo

