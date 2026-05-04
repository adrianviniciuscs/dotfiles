#!/bin/bash
# /* ---- 💫 Wallpaper Effects (Original & Clean) 💫 ---- */ #

# --- Variáveis ---
# (Mantidas originais)
terminal=alacritty
wallpaper_current="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
wallpaper_output="$HOME/.config/hypr/wallpaper_effects/.wallpaper_modified"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
rofi_theme="$HOME/.config/rofi/config-wallpaper-effect.rasi"
iDIR="$HOME/.config/swaync/images"

# Parâmetros de transição do SWWW
FPS=30
TYPE="wipe"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# --- Efeitos do ImageMagick ---
# (Mantidos EXATAMENTE como no original para garantir funcionamento)
declare -A effects=(
    ["No Effects"]="no-effects"
    ["Black & White"]="convert $wallpaper_current -colorspace gray -sigmoidal-contrast 10,40% $wallpaper_output"
    ["Blurred"]="convert $wallpaper_current -blur 0x10 $wallpaper_output"
    ["Charcoal"]="convert $wallpaper_current -charcoal 0x5 $wallpaper_output"
    ["Edge Detect"]="convert $wallpaper_current -edge 1 -negate -auto-level $wallpaper_output"
    ["Edge Detect Color"]="convert $wallpaper_current \\( +clone -edge 3 -negate \\) -compose multiply -composite -auto-level $wallpaper_output"    
    ["Edge Detect Overlay"]="convert $wallpaper_current \\( +clone -edge 3 -negate -colorspace gray \\) -compose overlay -composite $wallpaper_output"
    ["Emboss"]="convert $wallpaper_current -emboss 0x5 $wallpaper_output"
    ["Frame Raised"]="convert $wallpaper_current +raise 150 $wallpaper_output"
    ["Frame Sunk"]="convert $wallpaper_current -raise 150 $wallpaper_output"
    ["Negate"]="convert $wallpaper_current -negate $wallpaper_output"
    ["Oil Paint"]="convert $wallpaper_current -paint 4 $wallpaper_output"
    ["Posterize"]="convert $wallpaper_current -posterize 4 $wallpaper_output"
    ["Polaroid"]="convert $wallpaper_current -polaroid 0 $wallpaper_output"
    ["Sepia Tone"]="convert $wallpaper_current -sepia-tone 65% $wallpaper_output"
    ["Solarize"]="convert $wallpaper_current -solarize 80% $wallpaper_output"
    ["Sharpen"]="convert $wallpaper_current -sharpen 0x5 $wallpaper_output"
    ["Vignette"]="convert $wallpaper_current -vignette 0x3 $wallpaper_output"
    ["Vignette-black"]="convert $wallpaper_current -background black -vignette 0x3 $wallpaper_output"
    ["Zoomed"]="convert $wallpaper_current -gravity Center -extent 1:1 $wallpaper_output"
)   

# --- Funções ---

# Notificação que não empilha (flag -r 9991 substitui a anterior)
notify_clean() {
    local title="$1"
    local msg="$2"
    notify-send -r 9991 -u low -i "$iDIR/ja.png" "$title" "$msg"
}

# Aplica o wallpaper e gera cores (Paralelo)
apply_and_refresh() {
    local wallpaper_path="$1"
    
    # Roda SWWW (imagem) e Wallust (cores) ao mesmo tempo
    swww img -o "$focused_monitor" "$wallpaper_path" $SWWW_PARAMS &
    local swww_pid=$!
    
    wallust run "$wallpaper_path" -s &
    local wallust_pid=$!
    
    # Espera os dois terminarem
    wait $swww_pid $wallust_pid
    
    # Atualiza Waybar e outros apps
    "$SCRIPTSDIR/Refresh.sh"
}

# --- Principal ---
main() {
    # Garante que rofi não está rodando
    pkill rofi || true

    # Prepara menu
    options=("No Effects")
    for effect in "${!effects[@]}"; do
        [[ "$effect" != "No Effects" ]] && options+=("$effect")
    done

    # Exibe Rofi
    choice=$(printf "%s\n" "${options[@]}" | LC_COLLATE=C sort | rofi -dmenu -i -config "$rofi_theme" -p "✨ Efeito")

    # Processa escolha
    if [[ -n "$choice" ]]; then
        
        if [[ "$choice" == "No Effects" ]]; then
            notify_clean "Wallpaper" "Removendo efeitos..."
            
            # Restaura original
            apply_and_refresh "$wallpaper_current"
            cp "$wallpaper_current" "$wallpaper_output"
            
            notify_clean "Wallpaper" "Efeitos removidos com sucesso."
            
        elif [[ "${effects[$choice]}" ]]; then
            notify_clean "Processando" "Aplicando: $choice..."
            
            # Executa o comando original do array
            ${effects[$choice]}
            
            # Aplica o resultado
            apply_and_refresh "$wallpaper_output"
            
            notify_clean "Sucesso" "Efeito aplicado: $choice"
        else
            echo "Efeito '$choice' não reconhecido."
        fi
    fi
}

# Roda o script
main