#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 5.3 - Diagnostics Avancés Docker & Outils"

log_info "--- 1. Verification des binaires et versions ---"
check_cmd() {
    local cmd="$1"
    if command -v "$cmd" &>/dev/null; then
        log_success "OK: $cmd -> $($cmd --version 2>&1 | head -n 1)"
    else
        log_error "Outil manquant: $cmd"
        exit 1
    fi
}

check_cmd "docker"
check_cmd "lazydocker"

if docker compose version &>/dev/null; then
    log_success "OK: docker compose -> $(docker compose version)"
else
    log_error "Plugin Docker Compose manquant"
    exit 1
fi

if docker buildx version &>/dev/null; then
    log_success "OK: docker buildx -> $(docker buildx version)"
else
    log_error "Plugin Docker Buildx manquant"
    exit 1
fi

echo ""
log_info "--- 2. Isolation & Contextes Docker ---"
docker context ls

echo ""
log_info "--- 3. Verification des droits groupe docker ---"
if ! docker info &>/dev/null; then
    log_warn "L'utilisateur $USER a été ajouté au groupe 'docker'."
    log_warn "Pour appliquer l'accès sans réouvrir votre session, exécutez :"
    echo -e "      \033[1;33mnewgrp docker\033[0m"
    log_warn "Relancez ensuite ce script de validation."
    exit 0
fi

log_success "Accès au Socket Docker OK (sans sudo) !"

echo ""
log_info "--- 4. Inspection des paramètres système Docker ---"
log_info "Logging Driver : $(docker info --format '{{.LoggingDriver}}')"
log_info "Cgroup Driver  : $(docker info --format '{{.CgroupDriver}}')"
log_info "Cgroup Version : $(docker info --format '{{.CgroupVersion}}')"
log_info "Storage Driver : $(docker info --format '{{.Driver}}')"

echo ""
log_info "--- 5. Verification de Buildx & Compose ---"
docker buildx ls
docker compose ls

echo ""
log_success "Phase 5 (Docker Workstation) validée à 100% !"
