#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 1.2 - Mise à jour du système"
require_sudo

log_info "Mise à jour des index d'installation (apt update)..."
apt-get update -y

log_info "Mise à jour des paquets existants (apt upgrade)..."
apt-get upgrade -y

log_info "Nettoyage des paquets orphelins (autoremove)..."
apt-get autoremove -y
apt-get autoclean -y

log_success "Système parfaitement à jour."
