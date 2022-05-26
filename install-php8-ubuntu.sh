#!/bin/sh
#
# Instalação da última versão do PHP no Ubuntu
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2022-04-15
#

sudo add-apt-repository ppa:ondrej/php

PHP=`apt-cache search php8.* | grep "metapackage" | \
		sort | tail -1 | cut -d" " -f1`

sudo apt-get --no-install-recommends -y install \
	$PHP $PHP-xml $PHP-mbstring $PHP-curl

php -v
