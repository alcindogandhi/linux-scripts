#!/bin/sh
#
# Instalação do script de upgrade do sistema
#
# Nome: Alcindo Gandhi
# Data: 18/02/2023
#

FILE="/usr/local/sbin/upgrade"

if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

cat <<EOF >$FILE
#!/bin/sh
#
# Script de atualização do sistema
#

if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

apt-get update
if [ $? -ne 0 ]; then
    echo "Falha na atualização do repositório."
	exit 2
fi

apt-get -dy dist-upgrade
if [ $? -ne 0 ]; then
    echo "Falha no download dos pacotes."
	exit 3
fi

apt-get -y dist-upgrade
if [ $? -ne 0 ]; then
    echo "Falha na atualização dos pacotes."
	exit 4
fi

apt-get -y autoremove

flatpak --version >/dev/null
if [ $? -eq 0 ]; then
	flatpak -y update
	if [ $? -ne 0 ]; then
		echo "Falha na atualização dos pacotes do Flatpak."
		exit 5
	fi
fi

echo
echo "Atualizacao efetuada com sucesso."
echo
EOF

chmod +x $FILE

echo
echo "Script de atualização do sistema instalado com sucesso."
echo
