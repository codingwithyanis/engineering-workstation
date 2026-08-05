#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 2.6 - Déploiement des Dotfiles via Symlinks"

DOTFILES_SRC="$(cd "$SCRIPT_DIR/../../dotfiles" && pwd)"
TARGET_CONFIG="$HOME/.config/zsh"

ensure_dir "$HOME/.config"

# 1. Lien symbolique du dossier zsh entier
log_info "Création du lien symbolique pour ~/.config/zsh -> $DOTFILES_SRC/zsh"
ln -sfn "$DOTFILES_SRC/zsh" "$TARGET_CONFIG"

# 2. Lien symbolique du .zshrc à la racine du HOME
log_info "Création du lien symbolique pour ~/.zshrc -> $TARGET_CONFIG/.zshrc"
ln -sf "$TARGET_CONFIG/.zshrc" "$HOME/.zshrc"

# 3. Lien symbolique pour starship.toml
if [ -f "$DOTFILES_SRC/starship.toml" ]; then
    log_info "Création du lien symbolique pour ~/.config/starship.toml"
    ln -sf "$DOTFILES_SRC/starship.toml" "$HOME/.config/starship.toml"
fi

log_success "Le dépôt Git est désormais l'unique source de vérité (SSOT) des dotfiles."
