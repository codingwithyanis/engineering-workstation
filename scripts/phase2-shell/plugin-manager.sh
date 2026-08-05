#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 2.2 - Installation d'Antidote"

ANTIDOTE_DIR="$HOME/.antidote"

if [ ! -d "$ANTIDOTE_DIR" ]; then
    log_info "Clonage d'Antidote..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
    log_info "Antidote est déjà présent dans $ANTIDOTE_DIR."
fi

log_success "Antidote est prêt."
