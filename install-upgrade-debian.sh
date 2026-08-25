#!/bin/sh
#
# Instalação do script de upgrade do sistema
#
# Nome: Alcindo Gandhi
# Data: 18/02/2023
#

os_check() {
    OS_RELEASE_FILE="/etc/os-release"
    if [ ! -r "$OS_RELEASE_FILE" ]; then
        return 1
    fi

    . "$OS_RELEASE_FILE" || return 1

    case "$ID $ID_LIKE" in
        *ubuntu*) printf '%s\n' "ubuntu" ;;
        *debian*) printf '%s\n' "debian" ;;
        *) return 1 ;;
    esac
}

DISTRO="$(os_check)"
FILE="/usr/local/sbin/upgrade"
DIR="/usr/local/share/upgrade"
TMP_FILE=""

if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

if [ -z "$DISTRO" ]; then
    echo "Sistema operacional não suportado." 1>&2
    echo "Este script é compatível apenas com distribuições baseadas em Debian e Ubuntu." 1>&2
    exit 2
fi

if [ ! -d "$DIR" ]; then
    if ! install -d -o root -g root -m 0700 "$DIR"; then
        echo "Não foi possível criar o diretório de scripts auxiliares." 1>&2
        exit 3
    fi
fi

TMP_FILE=$(mktemp "${FILE}.XXXXXX") || {
    echo "Não foi possível criar o arquivo temporário." 1>&2
    exit 4
}
trap 'rm -f "$TMP_FILE"' 0 1 2 3 15

{
    printf '%s\n' '#!/bin/sh' '#' '# Script de atualização do sistema' '#' \
        "DISTRO='$DISTRO'" "DIR='$DIR'"
    cat <<'EOF'

if [ "$(id -u)" != "0" ]; then
   echo "Este script deve ser executado como root." 1>&2
   exit 1
fi

apt-get update
if [ $? -ne 0 ]; then
    echo "Falha na atualização do repositório."
    exit 2
fi

apt-get -dy dist-upgrade
if [ $? -ne 0 ]; then
    echo "Falha no download dos pacotes."
    exit 3
fi

apt-get -y dist-upgrade
if [ $? -ne 0 ]; then
    echo "Falha na atualização dos pacotes."
    exit 4
fi

if [ "$DISTRO" = "ubuntu" ]; then
    apt-get -y --with-new-pkgs upgrade
    if [ $? -ne 0 ]; then
        echo "Falha na atualização dos pacotes mantidos no Ubuntu."
        exit 5
    fi
fi

apt-get -y autoremove
if [ $? -ne 0 ]; then
    echo "Falha na remoção dos pacotes desnecessários."
    exit 6
fi

if [ -d "$DIR" ]; then
    if find "$DIR" -maxdepth 0 -user root ! -perm /022 >/dev/null 2>&1; then
        find "$DIR" -mindepth 1 -maxdepth 1 -type f -user root \
            ! -perm /022 -perm /111 -exec {} \;
        if [ $? -ne 0 ]; then
            echo "Falha na execução dos scripts auxiliares."
            exit 7
        fi
    else
        echo "Diretório de scripts auxiliares ignorado por permissões inseguras." 1>&2
        exit 7
    fi
fi

flatpak --version >/dev/null 2>&1
if [ $? -eq 0 ]; then
    flatpak -y update
    if [ $? -ne 0 ]; then
        echo "Falha na atualização dos pacotes do Flatpak."
        exit 8
    fi
fi

echo
echo "Atualizacao efetuada com sucesso."
echo
EOF
} >"$TMP_FILE" || {
    echo "Falha na geração do script de atualização." 1>&2
    exit 9
}

chmod 0755 "$TMP_FILE" || {
    echo "Falha ao definir as permissões do script de atualização." 1>&2
    exit 10
}

mv -f "$TMP_FILE" "$FILE" || {
    echo "Falha ao instalar o script de atualização." 1>&2
    exit 11
}

echo
echo "Script de atualização do sistema instalado com sucesso."
echo
