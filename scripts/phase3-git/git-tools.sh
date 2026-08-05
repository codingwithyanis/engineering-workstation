#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/versions.conf"

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

log_header "Phase 3.1 - Installation des outils Git (Delta, Lazygit & GitHub CLI)"

ensure_dir "$HOME/.local/bin"

# 1. Delta (version fixe depuis versions.conf)
if ! command_exists delta; then
    log_info "Installation de git-delta v${DELTA_VERSION}..."
    DELTA_DEB="git-delta_${DELTA_VERSION}_amd64.deb"
    wget -q "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${DELTA_DEB}" -O "/tmp/${DELTA_DEB}"
    sudo dpkg -i "/tmp/${DELTA_DEB}"
    rm -f "/tmp/${DELTA_DEB}"
    log_success "git-delta v${DELTA_VERSION} installé."
fi

# 2. Lazygit (version fixe depuis versions.conf)
if ! command_exists lazygit; then
    log_info "Installation de Lazygit v${LAZYGIT_VERSION}..."
    curl -sLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin/
    rm -f /tmp/lazygit /tmp/lazygit.tar.gz
    log_success "Lazygit v${LAZYGIT_VERSION} installé."
fi

# 3. GitHub CLI (gh) via dépôt officiel APT
if ! command_exists gh; then
    log_info "Installation de GitHub CLI (gh)..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod 644 /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update && sudo apt-get install -y gh
    log_success "GitHub CLI installé."
fi

log_success "Outillage Git & CLI prêt."
