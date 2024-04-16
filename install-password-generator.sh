#!/bin/sh
#
# Instalação do script de deração de senha aleatória.
#
# Autor: Alcindo Gandhi
# Data: 2024-04-16
#

FILE="/usr/local/bin/password-generator"
USER_ID_STR='$(id -u)'

if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

cat <<EOF >$FILE
#!/bin/sh
#
# Script de geração de senha aleatória com um tamanho especificado.
#

NUM=\${1:-16}

LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()' </dev/urandom | head -c \$NUM; echo

EOF

chmod +x $FILE

echo
echo "Script de geração de senha aleatória instalado com sucesso."
echo
