#!/bin/sh
#
# Script para instalar o GitHub Copilot CLI e a última versão estável do specify-cli
#

COPILOT_URL="https://gh.io/copilot-install"
UV_URL="https://astral.sh"
SPEC_URL="https://github.com/github/spec-kit.git"
SPEC_RELEASE_URL="https://api.github.com/repos/github/spec-kit/releases/latest"
SPEC_DEFAULT_TAG="v0.7.3"

# Aborta o script em caso de erro
#set -e

# Cria um diretório temporário e garante a limpeza ao sair
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"; echo "--- Arquivos temporários removidos ---"' EXIT
cd "$TMP_DIR"

echo "--- Instalando GitHub Copilot CLI ---"
curl -fsSL $COPILOT_URL > install-copilot.sh
if [ $? -ne 0 ]; then
    echo "[!] Erro ao baixar o script de instalação do Copilot CLI."
    exit 1
fi
bash install-copilot.sh

echo "--- Buscando última versão estável do specify-cli ---"

# 1. Obter a tag da última release estável via API do GitHub
LATEST_TAG=$(curl -s https://api.github.com/repos/github/spec-kit/releases/latest | grep tag_name | cut -d'"' -f4)
if [ -z "$LATEST_TAG" ]; then
    echo "[!] Erro ao identificar a última versão estável. Usando fallback para $DEFAULT_TAG."
    LATEST_TAG=$DEFAULT_TAG
fi

echo "[ok] Versao identificada: $LATEST_TAG"

# 2. Verificar se o uv está instalado
if ! command -v uv >/dev/null 2>&1; then
    echo "[+] Instalando uv..."
    curl -LsSf $UV_URL > install-uv.sh
    if [ $? -ne 0 ]; then
        echo "[!] Erro ao baixar o script de instalação do uv."
        exit 1
    fi
    sh install-uv.sh
    . "$HOME/.local/bin/env"
else
    echo "[ok] uv ja esta instalado."
fi

# 3. Instalar a versão estável específica
echo "[+] Instalando specify-cli@$LATEST_TAG..."
uv tool install specify-cli --from git+$SPEC_URL@$LATEST_TAG
if [ $? -ne 0 ]; then
    echo "[!] Erro ao instalar specify-cli@$LATEST_TAG."
    exit 1
fi

echo "--- Verificacao ---"
if command -v specify >/dev/null 2>&1; then
    echo "[Sucesso] specify-cli ($LATEST_TAG) instalado!"
    specify --version
else
    echo "[!] Instalacao concluida. Execute: . \$HOME/.local/bin/env"
fi
