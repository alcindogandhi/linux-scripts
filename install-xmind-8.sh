#!/bin/sh

ID="1oVN7rJrfzl3EGVIkEPD2ih0EgmCdBfoH"
URL="https://drive.google.com/uc?id=$ID"
FILE="xmind-8u9.tar.xz"

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

printf "Verificando a presença do Java 8 no sistema ..."
/opt/java/jdk-8/bin/java -version 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "NOK"
    echo "Erro! Java 8 não encontrado."
    echo "Execute o script \"install-jdk-8.sh\" antes de instalar o XMind 8."
	exit 1
fi

echo "OK"
printf "Efetuando o download do XMind-8 ... "
cd /tmp
wget --quiet --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$ID' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$ID" -O $FILE
if [ $? -ne 0 ]; then
    echo "NOK"
    echo "Erro! Falha no download do XMind 8."
    rm -f /tmp/cookies.txt $FILE
	exit 2
fi
rm -f /tmp/cookies.txt

echo "OK"
printf "Efetuando a instalação do programa ... "
cd /opt
rm -fr xmind-8
tar -xJf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo "NOK"
    echo "Erro! Falha ao descompactar o arquivo do XMind 8."
    rm -f $FILE
	exit 3
fi

cd /opt/xmind-8
sh register.sh

echo "OK"
echo
echo "XMind 8 instalado com sucesso."
echo
