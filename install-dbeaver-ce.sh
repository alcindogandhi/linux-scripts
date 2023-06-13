#!/bin/sh
#
# Instalação do DBeaver Database Manager
#
# Nome: Alcindo Gandhi
# Data: 13/06/2023
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

# Instalando os requisitos do script
wget --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro!"
    echo "Para a correta execução deste script, é necessário o programa \"wget\""
    exit 2
fi

curl --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro!"
    echo "Para a correta execução deste script, é necessário o programa \"curl\""
    exit 3
fi

VERSION=$(curl -s https://github.com/dbeaver/dbeaver/releases | grep "h2" | grep "sr-only" | head -1 | cut -d'>' -f2 | cut -d'<' -f1)
URL="https://github.com/dbeaver/dbeaver/releases/download/${VERSION}/dbeaver-ce-${VERSION}-linux.gtk.x86_64-nojdk.tar.gz"
FILE=$(basename $URL)
DIR="dbeaver-ce"

cd /opt
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    echo "Falha no download do arquivo $FILE"
    rm -f $FILE
	exit 4
fi

rm -fr "dbeaver-ce"
tar -xzf $FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f $FILE
	exit 5
fi

mv dbeaver $DIR
rm -f $FILE
cd $DIR

cat <<EOF >dbeaver-ce.desktop
[Desktop Entry]
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=dbeaver-ce
GenericName=Universal Database Manager
Comment=Universal Database Manager and SQL Client.
Path=/opt/$DIR/
Exec=/opt/$DIR/dbeaver
Icon=/opt/$DIR/dbeaver.png
Categories=IDE;Development
StartupWMClass=DBeaver
StartupNotify=true
Keywords=Database;SQL;IDE;JDBC;ODBC;MySQL;PostgreSQL;Oracle;DB2;MariaDB
MimeType=application/sql
EOF

cd /usr/share/applications
ln -fs /opt/$DIR/dbeaver-ce.desktop

echo
echo "Instalação do DBeaver CE $VERSION concluída com sucesso."
echo
