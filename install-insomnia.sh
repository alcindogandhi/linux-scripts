#!/bin/sh
#
# Instalação do Insomnia
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

VERSION=$(curl -s https://github.com/Kong/insomnia/releases/ | grep latest | grep download | cut -d'"' -f2 | cut -d'/' -f7 | cut -d'-' -f5 | cut -d'.' -f-3)
if [ -z "$VERSION" ]; then
	echo >&2
	echo >&2 "Erro! Falha na obtenção da ultima versão estável do Insomnia."
	echo >&2
	exit 2
fi

URL="https://github.com/Kong/insomnia/releases/download/core%40$VERSION/Insomnia.Core-$VERSION-x64.tar.gz"
FILE=$(basename $URL)
DIR=$(echo $FILE | cut -d'.' -f-4)

cd /opt
rm -f $FILE
printf "Efetuando o download do Insomnia $VERSION nos servidores do Github ... "
wget -q $URL -O $FILE
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha no download do Insomnia $VERSION"
	echo >&2
	exit 2
fi

echo "Ok"
printf "Instalando o programa ... "
rm -fr insomnia-*
tar -xzf $FILE
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha ao descompactar o arquivo do Insomnia $VERSION"
	echo >&2
	exit 2
fi
rm -fr $FILE

mv $DIR insomnia-$VERSION
cd insomnia-$VERSION
wget -q -O insomnia.svg https://raw.githubusercontent.com/alcindogandhi/linux-scripts/main/img/insomnia.svg
cat <<EOF >insomnia-$VERSION.desktop
[Desktop Entry]
Name=Insomnia
Exec=/opt/insomnia-$VERSION/insomnia %U
Terminal=false
Type=Application
Icon=/opt/insomnia-$VERSION/insomnia.svg
StartupWMClass=Insomnia
Comment=The Collaborative API Design Tool
Categories=Development;
Keywords=GraphQL;REST;gRPC;SOAP;openAPI;GitOps;
MimeType=x-scheme-handler/insomnia;
EOF
cd /usr/share/applications
rm -f insomnia-*.desktop
ln -s /opt/insomnia-$VERSION/insomnia-$VERSION.desktop

echo "Ok"
echo
echo "Insomnia $VERSION instalado com sucesso."
echo
