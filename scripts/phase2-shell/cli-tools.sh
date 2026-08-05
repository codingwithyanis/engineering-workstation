#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

log_header "Phase 2.4 - Installation des CLI Modernes"

# Retrait de 'tldr' de la liste APT (remplacé par tldr via npm/pip ou tealdeer si besoin)
APT_TOOLS=(ripgrep fd-find btop fastfetch jq tree direnv fzf neovim)

log_info "Installation des outils APT stables..."
sudo apt-get update && sudo apt-get install -y "${APT_TOOLS[@]}"

ensure_dir "$HOME/.local/bin"

# Liens symboliques pour 'fd', 'bat' et 'nvim'
if command_exists fdfind && [ ! -f "$HOME/.local/bin/fd" ]; then
    ln -s "$(which fdfind)" "$HOME/.local/bin/fd"
fi

if ! command_exists bat; then
    sudo apt-get install -y bat
    if [ ! -f "$HOME/.local/bin/bat" ]; then
        ln -s "$(which batcat)" "$HOME/.local/bin/bat"
    fi
fi

# Installation de zoxide
if ! command_exists zoxide; then
    log_info "Installation de zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# Installation de eza
if ! command_exists eza; then
    log_info "Configuration du dépôt APT pour eza..."
    sudo mkdir -p /etc/apt/keyrings
    if [ ! -f /etc/apt/keyrings/gierens.gpg ]; then
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    fi
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update && sudo apt-get install -y eza
fi

# Installation de yq
if ! command_exists yq; then
    log_info "Installation de yq (binary)..."
    sudo wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
    sudo chmod +x /usr/local/bin/yq
fi

log_success "Ensemble des CLI modernes installés."
