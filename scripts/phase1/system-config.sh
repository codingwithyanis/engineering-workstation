#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 1.5 - Configuration des Répertoires & Système"

# 1. Structure de dossiers selon la philosophie définie
WORKSPACE_DIRS=(
    "$HOME/Workspace/personal/projects"
    "$HOME/Workspace/personal/open-source"
    "$HOME/Workspace/personal/experiments"
    "$HOME/Workspace/work/clients"
    "$HOME/Workspace/work/products"
    "$HOME/Workspace/work/internal"
    "$HOME/Workspace/labs/experiments"
    "$HOME/Workspace/labs/prototypes"
    "$HOME/Workspace/labs/benchmarks"
    "$HOME/Workspace/shared/scripts"
    "$HOME/Workspace/shared/snippets"
    "$HOME/Workspace/shared/notes"
)

for dir in "${WORKSPACE_DIRS[@]}"; do
    ensure_dir "$dir"
done

# 2. S'assurer de la locale UTF-8
if ! locale | grep -q "UTF-8"; then
    log_info "Génération de la locale UTF-8..."
    sudo locale-gen en_US.UTF-8 fr_FR.UTF-8
fi

log_success "Arborescence du Workspace et configuration locale prêtes."
