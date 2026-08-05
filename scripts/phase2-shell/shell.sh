#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 2.1 - Installation & Configuration de Zsh"

if ! command_exists zsh; then
    log_info "Installation de Zsh..."
    sudo apt-get update && sudo apt-get install -y zsh
else
    log_info "Zsh est déjà installé."
fi

# Passer Zsh en shell par défaut si ce n'est pas le cas
CURRENT_SHELL="$(basename "$SHELL")"
if [ "$CURRENT_SHELL" != "zsh" ]; then
    log_info "Changement du shell par défaut vers Zsh pour $USER..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

log_success "Zsh est prêt."
