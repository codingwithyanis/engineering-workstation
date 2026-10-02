#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/versions.conf"

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

log_header "Phase 2.4 - Installation des CLI Modernes"

# Retrait de 'tldr' de la liste APT (remplacé par tldr via npm/pip ou tealdeer si besoin)
# 'neovim' est également retiré : la version des dépôts Ubuntu est trop ancienne
# pour kickstart.nvim (qui requiert Neovim >= 0.12, cf. bloc dédié plus bas).
APT_TOOLS=(ripgrep fd-find btop fastfetch tree direnv fzf)

log_info "Installation des outils APT stables..."
sudo apt-get update && sudo apt-get install -y "${APT_TOOLS[@]}"

ensure_dir "$HOME/.local/bin"

# Liens symboliques pour 'fd', 'bat' et 'nvim'
if command_exists fdfind && [ ! -f "$HOME/.local/bin/fd" ]; then
    ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

if ! command_exists bat; then
    sudo apt-get install -y bat
    if [ ! -f "$HOME/.local/bin/bat" ]; then
        ln -s "$(command -v batcat)" "$HOME/.local/bin/bat"
    fi
fi

# Installation de zoxide
if ! command_exists zoxide; then
    log_info "Installation de zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# Installation de la dernière release stable officielle de Neovim
NVIM_CURRENT_VERSION="$(nvim --version 2>/dev/null | head -1 | sed 's/^NVIM v//')"
NVIM_LATEST_VERSION="$(curl -fsSL --proto '=https' --tlsv1.2 https://api.github.com/repos/neovim/neovim/releases/latest | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p')"
if [ -z "$NVIM_LATEST_VERSION" ]; then
    log_error "Impossible de déterminer la dernière version stable de Neovim."
    exit 1
fi
if ! command_exists nvim || [ "$NVIM_CURRENT_VERSION" != "$NVIM_LATEST_VERSION" ]; then
    case "$(uname -m)" in
        x86_64) NVIM_ARCH="x86_64" ;;
        aarch64) NVIM_ARCH="arm64" ;;
        *) log_error "Architecture non supportée pour Neovim : $(uname -m)"; exit 1 ;;
    esac
    log_info "Installation de Neovim (binaire officiel)..."
    curl -fsSL --proto '=https' --tlsv1.2 "https://github.com/neovim/neovim/releases/download/v${NVIM_LATEST_VERSION}/nvim-linux-${NVIM_ARCH}.tar.gz" -o /tmp/nvim-linux.tar.gz
    rm -rf "$HOME/.local/share/nvim-latest"
    mkdir -p "$HOME/.local/share/nvim-latest"
    tar -xzf /tmp/nvim-linux.tar.gz --strip-components=1 -C "$HOME/.local/share/nvim-latest"
    rm /tmp/nvim-linux.tar.gz
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

log_success "Ensemble des CLI modernes installés."
