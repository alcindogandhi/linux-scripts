#!/bin/sh
#
# Instalação da última versão do PHPUnit
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2022-04-15
#

wget -O phpunit https://phar.phpunit.de/phpunit-9.phar
if [ $? -ne 0 ]; then
	echo >&2
	echo >&2 "Erro! Falha no download do PHPUnit"
	echo >&2
	exit 1
fi

chmod +x phpunit
sudo mv phpunit /usr/local/bin/
sudo chown root:root /usr/local/bin/phpunit
sudo touch /usr/local/bin/.phpunit.result.cache
sudo chown root:root /usr/local/bin/.phpunit.result.cache
sudo chmod 666 /usr/local/bin/.phpunit.result.cache

phpunit --version

