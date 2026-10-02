#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 5.1 - Installation de Docker Engine, Plugins & LazyDocker"

log_info "Suppression des paquets conflictuels..."
sudo apt-get remove -y docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc 2>/dev/null || true

log_info "Installation des prérequis système..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

source /etc/os-release
case "$ID" in
    ubuntu) DOCKER_REPO_OS="ubuntu"; DOCKER_CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}" ;;
    debian) DOCKER_REPO_OS="debian"; DOCKER_CODENAME="$VERSION_CODENAME" ;;
    *) log_error "Distribution non supportée par ce script : $ID"; exit 1 ;;
esac

log_info "Configuration de la clé GPG et du dépôt APT officiel..."
sudo install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
    sudo curl -fsSL --proto '=https' --tlsv1.2 "https://download.docker.com/linux/$DOCKER_REPO_OS/gpg" -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/$DOCKER_REPO_OS
Suites: $DOCKER_CODENAME
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo rm -f /etc/apt/sources.list.d/docker.list

log_info "Installation de Docker CE & Plugins (Buildx, Compose)..."
sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

source "$SCRIPT_DIR/../../config/versions.conf"
case "$(uname -m)" in
    x86_64) LAZYDOCKER_ARCH="x86_64" ;;
    aarch64) LAZYDOCKER_ARCH="arm64" ;;
    armv7l) LAZYDOCKER_ARCH="armv7" ;;
    *) log_error "Architecture non supportée pour LazyDocker : $(uname -m)"; exit 1 ;;
esac
log_info "Installation de LazyDocker v${LAZYDOCKER_VERSION}..."
curl -fsSL --proto '=https' --tlsv1.2 -o /tmp/lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_${LAZYDOCKER_ARCH}.tar.gz"
sudo tar -xzf /tmp/lazydocker.tar.gz -C /usr/local/bin lazydocker
rm -f /tmp/lazydocker.tar.gz

log_success "Docker Engine, Buildx, Compose et LazyDocker sont installés !"
