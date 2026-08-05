#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 1.6 - Validation de la Foundation"

ERRORS=0

check_tool() {
    if command_exists "$1"; then
        log_success "Outil disponible : $1"
    else
        log_error "Outil manquant : $1"
        ERRORS=$((ERRORS + 1))
    fi
}

check_tool "make"
check_tool "gcc"
check_tool "curl"
check_tool "git"

if [ -d "/etc/apt/keyrings" ]; then
    log_success "Dossier GPG keyrings présent (/etc/apt/keyrings)"
else
    log_error "Dossier GPG keyrings absent"
    ERRORS=$((ERRORS + 1))
fi

if [ $ERRORS -eq 0 ]; then
    log_success "PHASE 1 VALIDÉE : Le socle est prêt pour la Phase 2 (Shell)."
else
    log_error "Validation échouée avec $ERRORS erreur(s)."
    exit 1
fi
