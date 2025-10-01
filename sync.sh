#!/bin/bash

# --- CONFIGURAÇÃO ---
# 1. PASTAS dentro de ~/.config para copiar
FOLDERS_IN_CONFIG=("alacritty" "hypr" "i3" "nvim" "waybar")

# 2. ARQUIVOS soltos na sua pasta HOME (~) para copiar
FILES_IN_HOME=(".zshrc")

# 3. ARQUIVOS soltos DENTRO de ~/.config para copiar
FILES_IN_CONFIG=("tmux.conf")

# Caminhos de origem e destino
CONFIG_DIR="$HOME/.config"
HOME_DIR="$HOME"
DOTFILES_DIR="$HOME/.dotfiles"
# --- FIM DA CONFIGURAÇÃO ---

echo "--------------------------------------------------------"
mkdir -p "$DOTFILES_DIR"

# --- Seção 1: Copiando as PASTAS de .config ---
echo "Copiando pastas de $CONFIG_DIR..."
for folder in "${FOLDERS_IN_CONFIG[@]}"; do
    SOURCE_PATH="$CONFIG_DIR/$folder"
    if [ -d "$SOURCE_PATH" ]; then
        echo "-> Copiando pasta '$folder'..."
        cp -rf "$SOURCE_PATH" "$DOTFILES_DIR/"
    else
        echo "-> Aviso: Pasta '$folder' não encontrada. Pulando."
    fi
done

echo "--------------------------------------------------------"

# --- Seção 2: Copiando os ARQUIVOS da HOME ---
echo "Copiando arquivos de $HOME_DIR..."
for file in "${FILES_IN_HOME[@]}"; do
    SOURCE_PATH="$HOME_DIR/$file"
    if [ -f "$SOURCE_PATH" ]; then
        echo "-> Copiando arquivo '$file'..."
        cp -f "$SOURCE_PATH" "$DOTFILES_DIR/"
    else
        echo "-> Aviso: Arquivo '$SOURCE_PATH' não encontrado. Pulando."
    fi
done

echo "--------------------------------------------------------"

# --- Seção 3: Copiando os ARQUIVOS de .config ---
echo "Copiando arquivos de $CONFIG_DIR..."
for file in "${FILES_IN_CONFIG[@]}"; do
    SOURCE_PATH="$CONFIG_DIR/$file"
    if [ -f "$SOURCE_PATH" ]; then
        echo "-> Copiando arquivo '$file'..."
        cp -f "$SOURCE_PATH" "$DOTFILES_DIR/"
    else
        echo "-> Aviso: Arquivo '$SOURCE_PATH' não encontrado. Pulando."
    fi
done

echo "--------------------------------------------------------"
echo " Backup concluído."
