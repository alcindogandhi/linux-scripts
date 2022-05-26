#!/bin/sh
#
# Arquivo install-irpf.sh
#
# Instala a ultima versão do programa do IRPF no Linux.
#
# Autor: Alcindo Gandhi
# Data:  2022-05-26
#

DIR=$(pwd)
YEAR=${1:-$(date +%Y)}
URL=https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/download/pgd/dirpf
URL=$(curl -s $URL | grep Multiplataforma | grep $YEAR | cut -d\" -f4)
FILE=$(basename $URL)
FILE_DIR="IRPF$YEAR"

cd /tmp
rm -f $FILE
printf "Efetuando o download do arquivo nos servidores da Receita Federal ... "
wget -q $URL
if [ $? -ne 0 ]; then
    echo >&2
	echo >&2 "Erro! Falha no download do IRPF $YEAR"
	echo >&2
    cd $DIR
	exit 1
fi

echo "Ok"
echo "Instalando o programa"
cd ~/ProgramasRFB
wget -q -O rfb.ico https://raw.githubusercontent.com/alcindogandhi/linux-scripts/main/img/rfb.ico
unzip -qo /tmp/$FILE
rm -f /tmp/$FILE
cd $FILE_DIR

cat <<EOF >irpf-$YEAR.desktop
[Desktop Entry]
Encoding=UTF-8
Name=IRPF $YEAR
StartupWMClass=serpro-ppgd-app-IRPFPGD
Comment=Imposto de Renda $YEAR
Exec=java -jar $HOME/ProgramasRFB/IRPF$YEAR/irpf.jar
Icon=$HOME/ProgramasRFB/rfb.ico
Categories=Application;Office
Version=1.0
Type=Application
Terminal=0
EOF

cd /usr/share/applications
sudo ln -fs $HOME/ProgramasRFB/IRPF$YEAR/irpf-$YEAR.desktop

cd $DIR

echo
echo "IRPF $YEAR instalado com sucesso."
echo

