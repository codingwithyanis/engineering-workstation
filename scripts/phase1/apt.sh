#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 1.3 - Configuration APT Moderne"
require_sudo

# Préparation du dossier de clés GPG sécurisé (remplace apt-key déprécié)
ensure_dir "/etc/apt/keyrings"
chmod 0755 /etc/apt/keyrings

log_info "Support HTTPS pour APT activé."
apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common

log_success "Gestionnaire APT configuré aux normes de sécurité modernes."
