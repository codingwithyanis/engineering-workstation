#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 4.1 - Installation de mise"

ensure_dir "$HOME/.local/bin"

if ! command -v mise &>/dev/null; then
    log_info "Téléchargement du binaire mise..."
    curl https://mise.run | sh
    log_success "mise installé dans ~/.local/bin/mise"
else
    log_info "mise déjà présent : $(mise --version)"
fi

log_success "mise est prêt ; son activation Zsh est centralisée dans 99-integrations.zsh."
