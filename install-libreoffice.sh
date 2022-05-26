#!/bin/bash
#
# Script de atualizacao do Libreoffice no Debian.
#
# Autor: Alcindo Gandhi Barreto Almeida
# Dara: 05/06/2017
#

VER=$(curl -s https://pt-br.libreoffice.org/baixe-ja/libreoffice-novo/ | grep dl_download_link | head -1 | cut -d\" -f 4 | cut -d/ -f 7)
ARCH=x86_64
ARCH_FILE=x86-64
PACK=deb
LANG=pt-BR
SERVER=http://linorg.usp.br/LibreOffice
SERVER_PATH=$SERVER/stable/$VER/$PACK/$ARCH
MAIN_FILE=LibreOffice_"$VER"_Linux_"$ARCH_FILE"_"$PACK".tar.gz
HELP_FILE=LibreOffice_"$VER"_Linux_"$ARCH_FILE"_"$PACK"_helppack_"$LANG".tar.gz
LANG_FILE=LibreOffice_"$VER"_Linux_"$ARCH_FILE"_"$PACK"_langpack_"$LANG".tar.gz
UNPACK="tar -xzf"
DIR=_libreoffice_
FILES=( "$MAIN_FILE" "$HELP_FILE" "$LANG_FILE" )

echo
echo Script de atualizacao do LibreOffice
echo
echo Versao: $VER
echo Lingua: $LANG
echo Servidor: $SERVER
echo Path: $SERVER_PATH
echo

#echo $MAIN_FILE
#echo $HELP_FILE
#echo $LANG_FILE

# Removendo os arquivos do LibreOffice de instalações anteriores
sudo apt-get -y autoremove --purge "libreoffice*"

printf "Criando a pasta temporaria dos arquivos de dowload ... "
mkdir -p $DIR
echo "OK."

cd $DIR
mkdir -p $PACK

for f in "${FILES[@]}"
do
	printf "Arquivo %s\n" $f
	if [ ! -s $f ]; then
		printf "Baixando %s ...\n" $f
		wget -c $SERVER_PATH/$f
		if [ $? -ne 0 ]; then
			echo "ERRO!"
			echo "*** Falha no download do LibreOffice"
 			return 1
		fi
	fi
	$UNPACK $f
done

mv `find . -name *.$PACK` $PACK
cd $PACK

# Instalando os pacotes
sudo dpkg -i *.deb

# Retornando a pasta original
cd ../..

# Removendo a pasta com os arquivos temporarios
rm -fr $DIR

echo
echo "Instalação do Libreoffice $VER concluída com sucesso."
echo

