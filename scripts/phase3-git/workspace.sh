#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/user.conf"

log_header "Phase 3.4 - Arborescence Workspace"

WORKSPACE="$HOME/Workspace"

log_info "Création des dossiers sous $WORKSPACE..."

ensure_dir "$WORKSPACE/personal"
ensure_dir "$WORKSPACE/sys"
ensure_dir "$WORKSPACE/work"

log_success "Arborescence Workspace prête :"
log_info "  📁 $WORKSPACE/personal  -> Identité: Personal ($PERSONAL_EMAIL)"
log_info "  📁 $WORKSPACE/sys       -> Identité: Personal Sys ($PERSONAL_EMAIL_2)"
log_info "  📁 $WORKSPACE/work      -> Identité: Work ($WORK_EMAIL)"
