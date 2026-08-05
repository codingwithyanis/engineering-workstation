#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 1.1 - Audit Système"

log_info "OS : $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
log_info "Noyau Linux : $(uname -r)"
log_info "Architecture CPU : $(uname -m)"
log_info "Shell courant : $SHELL"
log_info "Utilisateur : $USER (UID: $EUID)"

if command_exists snap; list_snap=$(snap list 2>/dev/null); then
    log_warn "Snap est présent sur le système ($(echo "$list_snap" | wc -l) paquets installés)."
fi

log_success "Audit terminé."
