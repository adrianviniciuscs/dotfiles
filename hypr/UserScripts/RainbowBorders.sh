#!/bin/bash
# /* ---- 🌈 Borders Full Spectrum (Wallust) - OPTIMIZED ---- */ ##

# Caminho do arquivo de cores
WALLUST_COLORS="$HOME/.config/hypr/wallust/wallust-hyprland.conf"

# Velocidade da troca (em segundos) - aumentado para economizar CPU/bateria
SPEED=5

# Arquivo PID para evitar múltiplas instâncias
PID_FILE="/tmp/rainbow_borders_${USER}.pid"

# Função de limpeza
cleanup() {
    rm -f "$PID_FILE"
    exit 0
}

# Verifica se já está rodando
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "RainbowBorders já está rodando (PID: $OLD_PID)"
        exit 0
    fi
fi

# Salva PID atual e configura trap para limpeza
echo $$ > "$PID_FILE"
trap cleanup EXIT INT TERM

# --- Loop Infinito ---
while true; do
    # Verifica se o arquivo existe
    if [ -f "$WALLUST_COLORS" ]; then
        
        # 1. Extrai TODAS as cores hexadecimais (0xff...) do arquivo
        mapfile -t all_colors < <(grep -o '0xff[0-9a-fA-F]\{6\}' "$WALLUST_COLORS")

        # Verifica se achou cores
        if [ ${#all_colors[@]} -gt 0 ]; then
            
            # 2. Limita a 10 cores max para reduzir complexidade do gradiente
            # Embaralha e pega apenas 10 (menos processamento de GPU)
            selected_colors=($(shuf -e "${all_colors[@]}" | head -10 | tr '\n' ' '))

            # 3. Aplica as cores selecionadas na borda
            hyprctl keyword general:col.active_border "${selected_colors[*]} 270deg" >/dev/null 2>&1
        fi
        
    else
        # Fallback se não achar o arquivo (cinza)
        hyprctl keyword general:col.active_border "0xff555555" >/dev/null 2>&1
    fi

    sleep "$SPEED"
done