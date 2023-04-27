#!/bin/sh

URL="https://drive.google.com/uc?id=1oVN7rJrfzl3EGVIkEPD2ih0EgmCdBfoH"
FILE="xmind-8u9.tar.xz"

/opt/java/jdk-8/bin/java -version 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro! Java 8 não encontrado."
    echo "Execute o script \"install-jdk-8.sh\" antes de instalar o XMind 8."
	exit 1
fi

pip install --upgrade gdown 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Erro! Falha na instalação do GDown"
	exit 2
fi

cd /tmp
gdown https://drive.google.com/uc?id=1oVN7rJrfzl3EGVIkEPD2ih0EgmCdBfoH
if [ $? -ne 0 ]; then
    echo "Erro! Falha no download do XMind 8."
    rm -f $FILE
	exit 3
fi

cd /opt
sudo tar -xJf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo "Erro! Falha ao descompactar o arquivo do XMind 8."
    rm -f $FILE
	exit 4
fi

cd /opt/xmind-8
sh register.sh

echo "XMind 8 instalado com sucesso."
