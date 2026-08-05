#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORKSPACE_DIR"

if [ -f "$WORKSPACE_DIR/lib/common.sh" ]; then
    source "$WORKSPACE_DIR/lib/common.sh"
else
    echo "Erreur: Impossible de charger lib/common.sh"
    exit 1
fi

log_header "🚀 Lancement du Bootstrap global de la Workstation (Phases 1 à 5)"

if [ ! -f "$WORKSPACE_DIR/config/user.conf" ]; then
    log_error "config/user.conf introuvable."
    log_info "Copie le template et renseigne tes identités avant de relancer :"
    log_info "  cp config/user.conf.example config/user.conf"
    exit 1
fi

# --- PHASE 1 : Système & Fondations ---
log_info "==> [Phase 1] Vérification / Validation du Système..."
if ! "$WORKSPACE_DIR/scripts/phase1/validate.sh" &>/dev/null; then
    log_info "Installation / Configuration du Système..."
    "$WORKSPACE_DIR/scripts/phase1/audit.sh"
    sudo "$WORKSPACE_DIR/scripts/phase1/system-update.sh"
    sudo "$WORKSPACE_DIR/scripts/phase1/apt.sh"
    sudo "$WORKSPACE_DIR/scripts/phase1/packages.sh"
    "$WORKSPACE_DIR/scripts/phase1/system-config.sh"
    "$WORKSPACE_DIR/scripts/phase1/validate.sh"
fi
log_success "Phase 1 validée !"

# --- PHASE 2 : Shell & Dotfiles ---
log_info "==> [Phase 2] Vérification / Validation du Shell & Dotfiles..."
if ! "$WORKSPACE_DIR/scripts/phase2-shell/validate.sh" &>/dev/null; then
    log_info "Installation / Configuration du Shell..."
    "$WORKSPACE_DIR/scripts/phase2-shell/shell.sh"
    "$WORKSPACE_DIR/scripts/phase2-shell/plugin-manager.sh"
    "$WORKSPACE_DIR/scripts/phase2-shell/prompt.sh"
    "$WORKSPACE_DIR/scripts/phase2-shell/cli-tools.sh"
    "$WORKSPACE_DIR/scripts/phase2-shell/history.sh"
    "$WORKSPACE_DIR/scripts/phase2-shell/dotfiles.sh"
    "$WORKSPACE_DIR/scripts/phase2-shell/aliases.sh"
    "$WORKSPACE_DIR/scripts/phase2-shell/validate.sh"
fi
log_success "Phase 2 validée !"

# --- PHASE 3 : Git, SSH & Identités ---
log_info "==> [Phase 3] Vérification / Validation de Git, SSH & Identités..."
if ! "$WORKSPACE_DIR/scripts/phase3-git/validate.sh" &>/dev/null; then
    log_info "Installation / Configuration de Git & SSH..."
    "$WORKSPACE_DIR/scripts/phase3-git/git-tools.sh"
    "$WORKSPACE_DIR/scripts/phase3-git/ssh-config.sh"
    "$WORKSPACE_DIR/scripts/phase3-git/dotfiles-git.sh"
    "$WORKSPACE_DIR/scripts/phase3-git/workspace.sh"
    "$WORKSPACE_DIR/scripts/phase3-git/validate.sh"
fi
log_success "Phase 3 validée !"

# --- PHASE 4 : Runtimes (mise) ---
log_info "==> [Phase 4] Vérification / Installation des runtimes (mise)..."
if ! "$WORKSPACE_DIR/scripts/phase4-runtimes/validate.sh" &>/dev/null; then
    log_info "Installation / Configuration des Runtimes..."
    "$WORKSPACE_DIR/scripts/phase4-runtimes/install-mise.sh"
    "$WORKSPACE_DIR/scripts/phase4-runtimes/config-runtimes.sh"
    "$WORKSPACE_DIR/scripts/phase4-runtimes/install-stacks.sh"
    "$WORKSPACE_DIR/scripts/phase4-runtimes/validate.sh"
fi
log_success "Phase 4 validée !"

# --- PHASE 5 : Docker & Infrastructure ---
log_info "==> [Phase 5] Vérification / Installation de Docker & Infrastructure..."
if ! sudo -u "$USER" -g docker "$WORKSPACE_DIR/scripts/phase5-docker/validate.sh" &>/dev/null; then
    log_info "Installation / Configuration de Docker..."
    "$WORKSPACE_DIR/scripts/phase5-docker/install-docker.sh"
    "$WORKSPACE_DIR/scripts/phase5-docker/config-docker.sh"
    sudo -u "$USER" -g docker "$WORKSPACE_DIR/scripts/phase5-docker/validate.sh"
fi
log_success "Phase 5 validée !"

log_success "🎉 Workstation entièrement bootstrapée et validée (Phases 1 à 5) !"
