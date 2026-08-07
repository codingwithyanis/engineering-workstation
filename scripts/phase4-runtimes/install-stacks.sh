#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 4.3 - Provisionnement des Runtimes & Outils via mise"

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
eval "$(mise env -s bash)"

log_info "Installation de l'ensemble des stacks configurées..."
mise install --verbose

# Installation de tree-sitter-cli (requis par nvim-treesitter pour compiler les parsers, cf. kickstart.nvim)
if ! command_exists tree-sitter; then
    log_info "Installation de tree-sitter-cli (npm global)..."
    npm install -g tree-sitter-cli
fi

log_success "Provisionnement de la Phase 4 terminé !"
