#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 1.4 - Installation des paquets fondamentaux"
require_sudo

PACKAGES=(
    build-essential
    curl
    wget
    git
    unzip
    zip
    xz-utils
    tar
    procps
    lsb-release
)

log_info "Installation des outils de compilation et utilitaires de base..."
apt-get install -y "${PACKAGES[@]}"

log_success "Paquets fondamentaux installés."
