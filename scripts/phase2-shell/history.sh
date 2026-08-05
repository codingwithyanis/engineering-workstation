#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

export PATH="$HOME/.atuin/bin:$HOME/.local/bin:$PATH"

log_header "Phase 2.5 - Installation d'Atuin"

if ! command_exists atuin; then
    log_info "Installation d'Atuin (non-interactive)..."
    curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | bash -s -- --no-modify-path
else
    log_info "Atuin est déjà installé."
fi

log_success "Gestionnaire d'historique Atuin prêt."
