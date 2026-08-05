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
mise doctor

echo ""
if mise doctor 2>&1 | grep -q "is not installed"; then
log_error "Des outils sont encore manquants !"
exit 1
else
log_success "Phase 4 validée avec succès !"
fi
