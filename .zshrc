DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

export NVM_LAZY_LOAD=true
source "$HOME/.zsh-nvm.zsh"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

plugins=(
	git 
	zsh-autosuggestions
	) 
source $ZSH/oh-my-zsh.sh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh 
eval "$(zoxide init zsh --cmd cd)"

PATH_ADDITIONS=(
  "$HOME/.local/scripts"
  "/root/.cargo/bin"
  "/usr/local/go/bin"
  "~/modelsim/modelsim_ase/bin/"
  "$HOME/.android_sdk/cmdline-tools/latest/bin"
  "$HOME/.android_sdk/emulator"
  "$HOME/.flutter/flutter/bin"
)

for p in "${PATH_ADDITIONS[@]}"; do
  p=$(eval echo "$p") 
  if [[ ! -d "$p" ]]; then
    continue
  fi
  [[ ":$PATH:" != *":$p:"* ]] && PATH="$PATH:$p"
done


# History configuration
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups

# Completion styling
autoload -Uz compinit 

for dump in ~/.zcompdump(N.mh+24); do
	compinit
done
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
source /usr/share/doc/fzf/examples/key-bindings.zsh # Se ainda for necessário

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias air="~/.air"
alias checksize="df -h .; du -sh -- * | sort -hr"
alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'
alias wezconfig='nvim ~/.config/wezterm/'
export PATH="/usr/.local/bin:$PATH"



# Environment Variables
export STRAVA_CID=115065
export STRAVA_SKEY=d4dc9510f9c7a1cb47c50ddf89e9a3dbf1caf2e2
export QSYS_ROOTDIR="/home/adrian/intelFPGA_lite/23.1std/quartus/sopc_builder/bin"
export ANDROID_SDK_ROOT="$HOME/.android_sdk"


ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
#

# Custom keybindings
bindkey -e
bindkey -s ^f "tmux-sessionizer\n"
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

export PATH="/home/adrian/.local/bin:$PATH"


# Alias para Watermark-CLI
# Uso: wm arquivo.jpg
wm() {
    if [ -z "$1" ]; then
        echo "Uso: wm <arquivo_imagem>"
        return 1
    fi
    
    # Configurações fixas
    TEXTO="u/FAVCS • PREVIEW"
    COR="255, 255, 255, 90" # Branco suave
    SCALE="0.07"
    
    # Executa a ferramenta
    watermark-cli "$1" "$TEXTO" --color "$COR" --text-scale "$SCALE" --orientation -45
    
    echo "✅ Marca d'água aplicada em $1"
}
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
alias claude-pick="/home/adrian/projetos/free-claude-code/claude-pick"
