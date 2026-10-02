#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/user.conf"

log_header "Phase 3.2 - Clés SSH & Structure Modulaire Include (3 Identités)"

ensure_dir "$HOME/.ssh/config.d"
chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"

# Chemins des clés SSH
KEY_PERSONAL="$HOME/.ssh/id_ed25519_personal"
KEY_WORK="$HOME/.ssh/id_ed25519_work"

# Option passphrase interactive ou automatique via flag
NO_PASSPHRASE="${1:-}"

generate_key() {
    local key_path="$1"
    local comment="$2"
    
    if [ ! -f "$key_path" ]; then
        log_info "Génération de la clé SSH : $key_path"
        if [ "$NO_PASSPHRASE" = "--no-passphrase" ]; then
            ssh-keygen -t ed25519 -C "$comment" -f "$key_path" -N ""
        else
            echo "Entrez la passphrase pour $key_path ($comment) [laisser vide pour aucune] :"
            ssh-keygen -t ed25519 -C "$comment" -f "$key_path"
        fi
        log_success "Clé créée : $key_path"
    else
        log_info "La clé $key_path existe déjà."
    fi
}

# 1. Génération des clés
generate_key "$KEY_PERSONAL" "$PERSONAL_EMAIL"
generate_key "$KEY_WORK" "$WORK_EMAIL"

# 2. Déploiement du fichier d'hôtes GitHub/GitLab modulaire (SSOT, symlink)
log_info "Déploiement de ~/.ssh/config.d/github.conf (symlink)..."
DOTFILES_SSH_CONFD="$(cd "$SCRIPT_DIR/../../dotfiles/ssh/config.d" && pwd)"
ln -sfn "$DOTFILES_SSH_CONFD/github.conf" "$HOME/.ssh/config.d/github.conf"

# 3. Injection sécurisée et non-destructive de Include dans ~/.ssh/config
DOTFILES_SSH="$SCRIPT_DIR/../../dotfiles/ssh/config"
if [ ! -f "$HOME/.ssh/config" ]; then
    cp "$DOTFILES_SSH" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
elif ! grep -q "config.d" "$HOME/.ssh/config"; then
    log_info "Sauvegarde de ~/.ssh/config vers ~/.ssh/config.bak"
    cp "$HOME/.ssh/config" "$HOME/.ssh/config.bak"
    {
        printf '%s\n\n' 'Include ~/.ssh/config.d/*.conf'
        cat "$HOME/.ssh/config"
    } > "$HOME/.ssh/config.tmp"
    mv "$HOME/.ssh/config.tmp" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
fi

log_success "SSH multi-comptes configuré avec succès pour 3 identités."
