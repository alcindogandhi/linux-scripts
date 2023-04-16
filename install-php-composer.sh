#!/bin/sh
#
# Instalação da última versão do PHP Composer
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2022-04-15
#

php -v >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "É necessário o PHP para executar este script." 1>&2
    exit 2
fi

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

echo
composer --version
echo
