#!/bin/bash
# /* ---- Script Otimizado para Temas Alacritty ---- */ ##

# --- CONFIGURAÇÃO ---
# Arquivo principal do Alacritty
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"

# Diretório dos temas (AJUSTE AQUI SE NECESSÁRIO)
# Verifique se o caminho é .../themes/ ou .../themes/themes/
THEMES_DIR="$HOME/.config/alacritty/themes"

# Ícone para notificações (opcional)
ICON_OK="$HOME/.config/swaync/images/ja.png"
ICON_ERR="$HOME/.config/swaync/images/error.png"
# --- FIM DA CONFIGURAÇÃO ---

# 1. Verificações de Segurança
if [ ! -d "$THEMES_DIR" ]; then
    notify-send -u critical -i "$ICON_ERR" "Erro Alacritty" "Pasta de temas não encontrada:\n$THEMES_DIR"
    exit 1
fi

if [ ! -f "$ALACRITTY_CONFIG" ]; then
    notify-send -u critical -i "$ICON_ERR" "Erro Alacritty" "Arquivo de configuração não encontrado:\n$ALACRITTY_CONFIG"
    exit 1
fi

# 2. Prepara a lista de temas
# Busca arquivos .toml e remove a extensão para exibir no menu
mapfile -t themes_list < <(find -L "$THEMES_DIR" -type f -name "*.toml" -exec basename {} .toml \;)

if [ ${#themes_list[@]} -eq 0 ]; then
    notify-send -u critical -i "$ICON_ERR" "Erro Alacritty" "Nenhum tema encontrado na pasta."
    exit 1
fi

# 3. Exibe o Menu Rofi
# Adiciona opção Random no topo
choice=$(printf "Random\n%s" "$(printf '%s\n' "${themes_list[@]}")" | rofi -dmenu -i -p "🎨 Tema Alacritty:")

# Se o usuário cancelar (ESC), sai sem erro
if [ -z "$choice" ]; then
    exit 0
fi

# 4. Lógica de Seleção
if [ "$choice" == "Random" ]; then
    # Escolhe um aleatório da lista real
    selected_theme="${themes_list[RANDOM % ${#themes_list[@]}]}"
    notify-msg="Tema Aleatório: $selected_theme"
else
    selected_theme="$choice"
    notify-msg="Tema Selecionado: $selected_theme"
fi

# Caminho final do arquivo escolhido
theme_fullpath="$THEMES_DIR/$selected_theme.toml"

# 5. Aplica a mudança
# Substitui a linha que começa com 'import =' pelo novo caminho
# O delimitador | é usado para não confundir com as barras do caminho
if sed -i "s|^import = .*|import = [\"$theme_fullpath\"]|" "$ALACRITTY_CONFIG"; then
    notify-send -i "$ICON_OK" "Alacritty" "$notify-msg"
else
    notify-send -u critical -i "$ICON_ERR" "Erro" "Falha ao gravar no arquivo alacritty.toml"
fi 