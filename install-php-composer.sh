#!/bin/sh
#
# Instalação da última versão do PHP Composer
#
# Autor: Alcindo Gandhi Barreto Almeida
# Data:  2022-04-15
#

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

composer --version
