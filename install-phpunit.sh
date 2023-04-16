#!/bin/sh
#
# Instalação da última versão do PHPUnit
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2022-04-15
#

# Verifica se o script possui os privilégios necessários
if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

wget -O phpunit https://phar.phpunit.de/phpunit-9.phar
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha no download do PHPUnit"
	echo >&2
	exit 1
fi

chmod +x phpunit
mv phpunit /usr/local/bin/
chown root:root /usr/local/bin/phpunit
touch /usr/local/bin/.phpunit.result.cache
chown root:root /usr/local/bin/.phpunit.result.cache
chmod 666 /usr/local/bin/.phpunit.result.cache

phpunit --version
