#!/bin/bash
# /* ---- 🎵 Monitor de Capa (Formato e Cache Fix) ---- */ #

ART_OUTPUT="/tmp/hyde-mpris.png"
TEMP_OUTPUT="/tmp/hyde-mpris_temp.jpg" # Baixa como JPG primeiro

update_art() {
    url="$1"
    
    if [[ -z "$url" ]]; then
        rm -f "$ART_OUTPUT"
    elif [[ "$url" == http* ]]; then
        # 1. Baixa para um arquivo temporário
        curl -s -o "$TEMP_OUTPUT" "$url"
        # 2. Move para o oficial (sobrescreve atomicamente)
        mv "$TEMP_OUTPUT" "$ART_OUTPUT"
    elif [[ "$url" == file://* ]]; then
        cp "${url#file://}" "$ART_OUTPUT"
    fi
}

# Limpa sujeira antiga
rm -f "$ART_OUTPUT"

# Cria um placeholder vazio para o Hyprlock não reclamar no início
touch "$ART_OUTPUT"

playerctl metadata --format '{{mpris:artUrl}}' --follow | while read -r line; do
    update_art "$line"
done