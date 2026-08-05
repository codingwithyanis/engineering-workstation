#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 5.1 - Installation de Docker Engine, Plugins & LazyDocker"

log_info "Suppression des paquets conflictuels..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

log_info "Installation des prérequis système..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg jq

log_info "Configuration de la clé GPG et du dépôt APT officiel..."
sudo install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

log_info "Installation de Docker CE & Plugins (Buildx, Compose)..."
sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

log_info "Installation du CLI LazyDocker..."
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sLo /tmp/lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
sudo tar -xf /tmp/lazydocker.tar.gz -C /usr/local/bin lazydocker
rm -f /tmp/lazydocker.tar.gz

log_success "Docker Engine, Buildx, Compose et LazyDocker sont installés !"
