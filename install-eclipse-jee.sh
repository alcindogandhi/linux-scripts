#!/bin/sh
#
# Instalação do Eclipse JEE
#
# Nome: Alcindo Gandhi
# Data: 24/02/2023
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

# Instalando os requisitos do script
REQUIREMENTS=""
wget --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    REQUIREMENTS="$REQUIREMENTS wget"
fi

curl --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    REQUIREMENTS="$REQUIREMENTS curl"
fi

if [ -n "$REQUIREMENTS" ]; then
    apt-get -y install $REQUIREMENTS
    if [ $? -ne 0 ]; then
        echo "Falha na instalação dos requisitos para execução do script."
        exit 2
    fi
fi

DIR=$(pwd)
URL=$(printf "https://eclipse.c3sl.ufpr.br%s" $(curl -s https://www.eclipse.org/downloads/packages/ | grep "jee" | grep "gtk-x86_64" | cut -d"'" -f2 | cut -d'=' -f2))
FILE=$(basename $URL)

mkdir -p /opt/eclipse
cd /opt/eclipse
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    echo "Falha no download do arquivo $FILE"
    rm -f $FILE
    cd $DIR
	exit 3
fi

tar -xzf $FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f $FILE
    cd $DIR
	exit 3
fi

rm -f $FILE
mv eclipse jee
cd /opt/eclipse/jee

cat <<EOF >eclipse-jee.desktop
[Desktop Entry]
Type=Application
Name=Eclipse
Comment=Eclipse Integrated Development Environment
Icon=/opt/eclipse/jee/icon.xpm
Exec=/opt/eclipse/jee/eclipse
Terminal=false
Categories=Development;IDE;Java
EOF

cd /usr/share/applications
ln -fs /opt/eclipse/jee/eclipse-jee.desktop

cd $DIR
echo
echo "Instalação do Eclipse JEE concluída com sucesso."
echo
