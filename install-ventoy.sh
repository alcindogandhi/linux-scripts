#!/bin/sh
#
# Script para download da última versão do Ventoy
#
# Autor: Alcindo Gandhi
# Data: 25/03/2023
#

DIR=$(pwd)
VERSION=$(curl -s https://github.com/ventoy/Ventoy/releases | grep sr-only | head -3 | grep h2 | cut -d'>' -f2 | cut -d' ' -f2)
URL=https://github.com/ventoy/Ventoy/releases/download/v$VERSION/ventoy-${VERSION}-linux.tar.gz
FILE=$(basename $URL)
FILE_DIR=$(echo "$FILE" | cut -d'-' -f1-2)

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

cd /tmp
rm -f $FILE
printf "Efetuando o download do Ventoy nos servidores do Github ... "
wget -q $URL
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha no download do Ventoy $VERSION"
	echo >&2
    cd $DIR
	exit 2
fi

echo "Ok"
printf "Instalando o programa ... "
cd /opt
rm -fr $FILE_DIR
tar -xzf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha ao descompactar o arquivo do Ventoy $VERSION"
	echo >&2
    cd $DIR
	exit 2
fi
rm -f ventoy /tmp/$FILE

ln -s $FILE_DIR ventoy
cd $FILE_DIR
wget -q -O ventoy.png https://raw.githubusercontent.com/alcindogandhi/linux-scripts/main/img/ventoy.png
cat <<EOF >ventoy.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Ventoy
Comment=Ventou $VERSION
Exec=/opt/ventoy/VentoyGUI.x86_64
Icon=/opt/ventoy/ventoy.png
Categories=Application;System
Version=1.0
Type=Application
Terminal=0
EOF

cd /usr/share/applications
rm -f ventoy.desktop
ln -s /opt/ventoy/ventoy.desktop

cd $DIR

echo "Ok"
echo
echo "Ventoy $VERSION instalado com sucesso."
echo
