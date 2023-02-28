#!/bin/sh
#
# Instalação do Wildfly
#
# Nome: Alcindo Gandhi
# Data: 27/02/2023
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

VERSION=$(curl -s https://api.github.com/repos/wildfly/wildfly/releases/latest | grep tag_name | cut -d '"' -f 4)
FILE="wildfly-$VERSION.tar.gz"
URL="https://github.com/wildfly/wildfly/releases/download/$VERSION/$FILE"
WILDFLY=wildfly-$VERSION
DIR=$(pwd)

# Baixando o Wildfly do repositório
echo "### Efetuando o download do Wildfly $VERSION ###"
cd /opt
ls $FILE >/dev/null 2>&1
if [ $? -ne 0 ]; then
    wget $URL -O $FILE
    if [ $? -ne 0 ]; then
        echo "Falha no download do arquivo $FILE"
        rm -f $FILE
        cd $DIR
        exit 3
    fi
fi

echo "### Descompactando o arquivo baixando ###"
rm -fr $WILDFLY
tar -xzf $FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f $FILE
    cd $DIR
	exit 3
fi
rm -fr $FILE wildfly
mv $WILDFLY wildfly

# Configurando o sistema
echo "### Configurando o sistema ###"
groupadd --system wildfly
useradd -s /sbin/nologin --system -d /opt/wildfly  -g wildfly wildfly

mkdir -p /etc/wildfly

cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/
cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/
cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/

chmod +x /opt/wildfly/bin/launch.sh
chown -R wildfly:wildfly /opt/wildfly

systemctl daemon-reload
systemctl start wildfly
systemctl enable wildfly
systemctl -l --no-pager status wildfly

echo "### Criando os usuários do servidor ###"
/opt/wildfly/bin/add-user.sh
