#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/user.conf"

log_header "Phase 3.4 - Arborescence Workspace"

WORKSPACE="$HOME/Workspace"

log_info "Création des dossiers sous $WORKSPACE..."

for dir in \
    "$WORKSPACE/personal/projects" \
    "$WORKSPACE/personal/open-source" \
    "$WORKSPACE/personal/experiments" \
    "$WORKSPACE/work/clients" \
    "$WORKSPACE/work/products" \
    "$WORKSPACE/work/internal" \
    "$WORKSPACE/labs/experiments" \
    "$WORKSPACE/labs/prototypes" \
    "$WORKSPACE/labs/benchmarks" \
    "$WORKSPACE/shared/scripts" \
    "$WORKSPACE/shared/snippets" \
    "$WORKSPACE/shared/notes"; do
    ensure_dir "$dir"
done

log_success "Arborescence Workspace prête :"
log_info "  📁 $WORKSPACE/personal  -> Identité: Personal ($PERSONAL_EMAIL)"
log_info "  📁 $WORKSPACE/work      -> Identité: Work ($WORK_EMAIL)"
log_info "  📁 $WORKSPACE/labs      -> Identité: Personal ($PERSONAL_EMAIL)"
