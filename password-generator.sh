#!/bin/sh
#
# Gera uma senha aleatória com m tamanho especificado.
#
# Author: Alcindo Gandhi
# Date: 2024-04-16
#

NUM=${1:-16}

LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()' </dev/urandom | head -c $NUM; echo

