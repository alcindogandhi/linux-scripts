#!/bin/sh
#
# Instalação do suporte a Julia
#
# Nome: Alcindo Gandhi
# Data: 21/06/2022
#

DIR=$(pwd)
URL=$(curl -s https://julialang.org/downloads/ | tidy 2>/dev/null | grep "linux/x64" | head -1 | cut -d'"' -f2)
FILE=$(echo $URL | cut -d'/' -f8)
NAME=$(echo $FILE | cut -d'-' -f-2)

cd /tmp
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    echo "Falha no download do arquivo $FILE"
    rm -f $FILE
	exit 2
fi

cd /opt
sudo rm -fr $NAME
sudo rm -f $(ls -l /opt/julia 2>/dev/null | awk '{print $11}')
sudo tar -xzf /tmp/$FILE
if [ $? -ne 0 ]; then
    echo "Falha ao descompactar o arquivo $FILE"
    rm -f /tmp/$FILE
	exit 3
fi

sudo rm -f /opt/julia /usr/local/bin/julia
sudo ln -s $NAME julia
sudo ln -s /opt/julia/bin/julia /usr/local/bin/julia
rm /tmp/$FILE

cd /tmp
cat <<EOF >install.jl
using Pkg
Pkg.add("IJulia")
using IJulia
installkernel("Julia")
EOF

julia install.jl
if [ $? -ne 0 ]; then
    echo "Falha na instalação do kernel do Julia"
    rm -f /tmp/install.jl
	exit 4
fi
rm -f /tmp/install.jl

cd $DIR
