#!/bin/sh
#
# Instalação do JDK 8
#
# Nome: Alcindo Gandhi
# Data: 22/03/2023
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

DIR=$(pwd)
LATEST_PAGE="https://www.oracle.com/java/technologies/downloads/#java8"
DOWNFILE=index.html

# Get file list
cd /tmp
wget $LATEST_PAGE
LATEST_VERSION=`grep 'Java SE Development Kit 8' $DOWNFILE | head -1 | sed 's/.*\(8u.*\)<.*/\1/'`
LATEST_PATCH=`echo $LATEST_VERSION | sed 's/8u//g'`
LATEST_URL=`grep data-file= $DOWNFILE | grep -E "jdk-$LATEST_VERSION-linux-x64.tar.gz" | sed "s/.*data-file='\(.*\)'/\1/"`
rm $DOWNFILE

mkdir -p /opt/java
cd /opt/java

FILE=jdk-${LATEST_VERSION}-linux-x64.tar.gz
VERSION=`echo $LATEST_URL | awk -F\/ '{print $7}' | sed 's/8u//g'`
HASH=`echo $LATEST_URL | awk -F\/ '{print $8}'`
URL="https://javadl.oracle.com/webapps/download/GetFile/1.8.0_$VERSION/$HASH/linux-i586/$FILE"
wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $URL
if [ $? -ne 0 ]; then
    echo "Falha no download do arquivo $FILE"
    rm -f $FILE
    cd $DIR
	exit 2
fi

JDK_HOME=$(tar -ztf /opt/java/jdk-8u361-linux-x64.tar.gz | head -1 | cut -d'/' -f1)
rm -fr $JDK_HOME
tar -xzf $FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f $FILE
    cd $DIR
	exit 3
fi
rm -f $FILE jdk-8
ln -s $JDK_HOME jdk-8

cd $DIR
