#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 4.4 - Diagnostics et Validation Phase 4"

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
eval "$(mise env -s bash)"

log_info "--- Bilan des versions actives ---"
mise current

echo ""
log_info "--- Exécution de mise doctor ---"
if ! DOCTOR_OUTPUT="$(mise doctor 2>&1)"; then
    printf '%s\n' "$DOCTOR_OUTPUT"
    log_error "mise doctor a détecté un problème."
    exit 1
fi
printf '%s\n' "$DOCTOR_OUTPUT"

echo ""
log_info "--- Vérification des versions déclarées ---"
if ! mise install --dry-run-code >/dev/null; then
    log_error "Des runtimes sont absents ou ne correspondent pas à la configuration."
    exit 1
fi

log_success "Phase 4 validée avec succès !"
