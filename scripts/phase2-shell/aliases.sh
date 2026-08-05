#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 2.7 - Validation de la configuration des Alias & Fonctions"

ALIASES_DIR="$HOME/.config/zsh/aliases"
FUNCTIONS_FILE="$HOME/.config/zsh/conf.d/functions.zsh"

if [ -d "$ALIASES_DIR" ] && [ -n "$(find "$ALIASES_DIR" -maxdepth 1 -name '*.zsh' -print -quit)" ]; then
    log_success "Modules d'alias détectés dans $ALIASES_DIR."
else
    log_error "Aucun module d'alias trouvé dans $ALIASES_DIR."
    exit 1
fi

if [ -f "$FUNCTIONS_FILE" ]; then
    log_success "Fichier de fonctions détecté dans $FUNCTIONS_FILE."
else
    log_error "Fichier de fonctions introuvable : $FUNCTIONS_FILE."
    exit 1
fi

log_success "Alias et fonctions configurés."
