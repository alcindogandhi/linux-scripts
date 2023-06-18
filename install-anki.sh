#!/bin/sh
#
# Instalação do Anki
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

SCRIPT=$(readlink -f "$0")
VERSION=$(curl -s "https://github.com/ankitects/anki/releases/" | grep "<h2" | head -1 | cut -d'>' -f2 | cut -d'<' -f1)
URL="https://github.com/ankitects/anki/releases/download/$VERSION/anki-$VERSION-linux-qt6.tar.zst"
FILE=$(basename $URL)
DIR=$(echo $FILE | cut -d'.' -f-3)

cd /opt
rm -f $FILE
wget $URL -O $FILE
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha no download do Anki $VERSION"
	echo >&2
	exit 2
fi

tar --use-compress-program=unzstd -xf $FILE
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha ao descompactar o arquivo do Anki $VERSION"
	echo >&2
	exit 2
fi
rm -fr $FILE "anki-*"
mv $DIR anki-$VERSION
cd anki-$VERSION

cat <<EOF >anki.desktop
[Desktop Entry]
Name=Anki
Comment=An intelligent spaced-repetition memory training program
GenericName=Flashcards
Exec=/opt/anki-$VERSION/anki %f
TryExec=/opt/anki-$VERSION/anki
Icon=/opt/anki-$VERSION/anki.xpm
Categories=Education;Languages;KDE;Qt;
Terminal=false
Type=Application
Version=1.0
MimeType=application/x-apkg;application/x-anki;application/x-ankiaddon;
#should be removed eventually as it was upstreamed as to be an XDG specification called SingleMainWindow
X-GNOME-SingleWindow=true
SingleMainWindow=true
EOF
rm -f /usr/share/applications/anki.desktop
cp $SCRIPT install.sh

cat <<EOF >uninstall.sh
#!/bin/sh

if [ \$(id -u) != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

cd /
xdg-mime uninstall /opt/anki-$VERSION/anki.xml
rm -fr /usr/local/bin/anki
rm -fr /usr/share/applications/anki-$VERSION.desktop
rm -fr /usr/share/man/man1/anki.1
rm -fr /opt/anki-$VERSION

echo "Anki $VERSION removido com sucesso"

EOF

xdg-mime install anki.xml --novendor
xdg-mime default anki.desktop application/x-colpkg
xdg-mime default anki.desktop application/x-apkg
xdg-mime default anki.desktop application/x-ankiaddon

cd /usr/local/bin && ln -fs /opt/anki-$VERSION/anki
cd /usr/share/applications && ln -fs /opt/anki-$VERSION/anki.desktop
cd /usr/share/man/man1 && ln -fs /opt/anki-$VERSION/anki.1

echo
echo "Anki $VERSION instalado com sucesso."
echo
