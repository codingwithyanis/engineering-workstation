#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

log_header "Phase 2.4 - Installation des CLI Modernes"

# Retrait de 'tldr' de la liste APT (remplacé par tldr via npm/pip ou tealdeer si besoin)
# 'neovim' est également retiré : la version des dépôts Ubuntu est trop ancienne
# pour kickstart.nvim (qui requiert Neovim >= 0.12, cf. bloc dédié plus bas).
APT_TOOLS=(ripgrep fd-find btop fastfetch jq tree direnv fzf)

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

# Installation de Neovim (release officielle, requis >= 0.12 pour kickstart.nvim)
NVIM_MIN_VERSION="0.12.0"
NVIM_CURRENT_VERSION="$(nvim --version 2>/dev/null | head -1 | sed 's/^NVIM v//')"
if ! command_exists nvim || [ "$(printf '%s\n%s\n' "$NVIM_MIN_VERSION" "$NVIM_CURRENT_VERSION" | sort -V | head -1)" != "$NVIM_MIN_VERSION" ]; then
    log_info "Installation de Neovim (binaire officiel)..."
    curl -sSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim-linux-x86_64.tar.gz
    rm -rf "$HOME/.local/share/nvim-latest"
    mkdir -p "$HOME/.local/share/nvim-latest"
    tar -xzf /tmp/nvim-linux-x86_64.tar.gz --strip-components=1 -C "$HOME/.local/share/nvim-latest"
    rm /tmp/nvim-linux-x86_64.tar.gz
    ln -sfn "$HOME/.local/share/nvim-latest/bin/nvim" "$HOME/.local/bin/nvim"
fi

# Installation de herdr
if ! command_exists herdr; then
    log_info "Installation de herdr..."
    curl -fsSL https://herdr.dev/install.sh | sh
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
