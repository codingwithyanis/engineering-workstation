#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

log_header "Phase 2.3 - Installation de Starship Prompt"

if ! command_exists starship; then
    log_info "Téléchargement et installation de Starship via l'installeur officiel..."
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
else
    log_info "Starship est déjà installé."
fi

log_success "Starship Prompt est prêt."
