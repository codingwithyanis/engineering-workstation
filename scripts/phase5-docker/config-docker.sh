#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 5.2 - Configuration Avancée du Daemon & Workspace Infrastructure"

log_info "Configuration des groupes d'accès..."
sudo groupadd -f docker
sudo usermod -aG docker "$USER"

log_info "Configuration de /etc/docker/daemon.json (Log driver 'local' & BuildKit)..."
sudo mkdir -p /etc/docker
cat <<'DAEMON_CONFIG' | sudo tee /etc/docker/daemon.json > /dev/null
{
  "log-driver": "local",
  "log-opts": {
    "max-size": "20m",
    "max-file": "5"
  },
  "features": {
    "buildkit": true
  }
}
DAEMON_CONFIG

log_info "Activation de BuildKit dans ~/.docker/config.json..."
mkdir -p "$HOME/.docker"
cat <<'USER_CONFIG' > "$HOME/.docker/config.json"
{
  "features": {
    "buildkit": "true"
  }
}
USER_CONFIG

log_info "Création de la structure ~/Infrastructure/docker/..."
INFRA_DIR="$HOME/Infrastructure/docker"
mkdir -p "$INFRA_DIR"/{postgres,mysql,mariadb,redis,valkey,rabbitmq,kafka,nginx,traefik,caddy,keycloak,minio,elastic,opensearch,grafana,prometheus,loki,tempo,mailpit,selenium}

log_info "Redémarrage du service Docker..."
if command -v systemctl &>/dev/null && systemctl is-systemd-running 2>/dev/null; then
    sudo systemctl enable docker
    sudo systemctl restart docker
else
    sudo service docker restart 2>/dev/null || true
fi

log_success "Daemon Docker configuré et arborescence ~/Infrastructure/docker créée avec succès !"
