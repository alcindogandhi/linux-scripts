#!/bin/sh
#
# Instalação do Navegador Brave no Debian, Ubuntu e derivados
#
# Nome: Alcindo Gandhi
# Data: 29/01/2024
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

# Instalando os requisitos do script
curl --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    apt-get -y install curl
    if [ $? -ne 0 ]; then
        echo "Erro! Falha na instalação dos requisitos para execução do script (curl)."
        exit 2
    fi
fi

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
if [ $? -ne 0 ]; then
    echo "Erro! Falha na instalação das chaves do repositório do Brave."
    exit 3
fi

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | tee /etc/apt/sources.list.d/brave-browser-release.list

apt update
apt -y install brave-browser
if [ $? -ne 0 ]; then
    echo "Erro! Falha na instalação do Brave."
    exit 4
fi

echo
echo "### Instalação do Brave efetuada com sucesso. ###"
echo
