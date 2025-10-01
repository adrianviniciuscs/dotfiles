#!/bin/bash
# /* ---- Adaptado do script de JaKooLit para temas Alacritty ---- */ ##
# Script para selecionar um tema do Alacritty com um menu Rofi.

# --- CONFIGURAÇÃO ---
# Arquivo de configuração principal do Alacritty
ALACRITTY_CONFIG_FILE="$HOME/.config/alacritty/alacritty.toml"

# Diretório onde você guarda seus temas .toml do Alacritty
THEMES_DIR="$HOME/.config/alacritty/themes/themes/"

# (Opcional) Caminho para um tema Rofi customizado para este menu
# Deixe comentado para usar o tema padrão do Rofi
# ROFI_THEME="$HOME/.config/rofi/config-alacritty.rasi"

# (Opcional) Diretório para ícones de notificação
ICONS_DIR="$HOME/.config/swaync/images"
# --- FIM DA CONFIGURAÇÃO ---


# Verifica se o diretório de temas existe
if [ ! -d "$THEMES_DIR" ]; then
  notify-send -u critical -i "${ICONS_DIR}/error.png" "Erro" "Diretório de temas do Alacritty não encontrado em '$THEMES_DIR'"
  exit 1
fi

# Pega todos os temas .toml, remove o caminho e a extensão
themes_array=($(find -L "$THEMES_DIR" -type f -name "*.toml" -exec basename {} \; | sed -e "s/\.toml$//"))

# Adiciona a opção "Random" no início da lista
themes_array=("Random" "${themes_array[@]}")

# Monta o comando do Rofi
if [ -n "$ROFI_THEME" ]; then
  rofi_command="rofi -i -dmenu -config $ROFI_THEME"
else
  rofi_command="rofi -i -dmenu -p 'Tema Alacritty:'"
fi


# Função que exibe o menu
menu() {
  for theme in "${themes_array[@]}"; do
    echo "$theme"
  done
}

# Função principal
main() {
  choice=$(menu | ${rofi_command})

  # Se nada for selecionado (pressionar ESC), não faz nada
  if [ -z "$choice" ]; then
    exit 0
  fi

  if [[ "$choice" == "Random" ]]; then
    # Pega um tema aleatório da lista (excluindo a opção "Random")
    random_theme=${themes_array[$((RANDOM % (${#themes_array[@]} - 1) + 1))]}
    theme_to_set="$random_theme"
    notify-send -i "${ICONS_DIR}/ja.png" "Alacritty" "Tema aleatório aplicado: $random_theme"
  else
    # Define o tema como o escolhido
    theme_to_set="$choice"
    notify-send -i "${ICONS_DIR}/ja.png" "Alacritty" "Tema selecionado: $choice"
  fi
  
  # Caminho completo para o arquivo de tema que será importado
  theme_path="$THEMES_DIR/$theme_to_set.toml"

  # Verifica se o arquivo de configuração do Alacritty existe
  if [ -f "$ALACRITTY_CONFIG_FILE" ]; then
    # Usa `sed` para substituir a linha de import.
    # Usar `|` como delimitador no sed evita problemas com as barras `/` do caminho.
    sed -i "s|^import = .*|import = [\"$theme_path\"]|" "$ALACRITTY_CONFIG_FILE"
    notify-send -i "${ICONS_DIR}/ja.png" "Alacritty" "Tema aplicado!"
  else
    notify-send -u critical -i "${ICONS_DIR}/error.png" "Erro" "Arquivo '$ALACRITTY_CONFIG_FILE' não encontrado!"
  fi
}

# Garante que não haja outra instância do Rofi rodando
if pidof rofi > /dev/null; then
  pkill rofi
fi

main
