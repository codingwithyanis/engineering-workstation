#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/user.conf"

log_header "Phase 3.2 - Clés SSH & Structure Modulaire Include (3 Identités)"

ensure_dir "$HOME/.ssh/config.d"
chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"

# Chemins des 3 clés SSH
KEY_PERSONAL="$HOME/.ssh/id_ed25519_personal"
KEY_PERSONAL_2="$HOME/.ssh/id_ed25519_personal_sys"
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

# 1. Génération des 3 clés
generate_key "$KEY_PERSONAL" "$PERSONAL_EMAIL"
generate_key "$KEY_PERSONAL_2" "$PERSONAL_EMAIL_2"
generate_key "$KEY_WORK" "$WORK_EMAIL"

# 2. Configuration Hôtes GitHub/GitLab modulaires (~/.ssh/config.d/github.conf)
log_info "Mise à jour de ~/.ssh/config.d/github.conf..."

cat <<EOF > "$HOME/.ssh/config.d/github.conf"
# 1. Clé Personnelle Principale ($PERSONAL_EMAIL)
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes

Host gitlab-personal
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes

# 2. Clé Personnelle Secondaire / Sys ($PERSONAL_EMAIL_2)
Host github-sys
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal_sys
    IdentitiesOnly yes

Host gitlab-sys
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal_sys
    IdentitiesOnly yes

# 3. Clé Professionnelle ($WORK_EMAIL)
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes

Host gitlab-work
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes
EOF

chmod 600 "$HOME/.ssh/config.d/github.conf"

# 3. Injection sécurisée et non-destructive de Include dans ~/.ssh/config
DOTFILES_SSH="$SCRIPT_DIR/../../dotfiles/ssh/config"
if [ ! -f "$HOME/.ssh/config" ]; then
    cp "$DOTFILES_SSH" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
elif ! grep -q "config.d" "$HOME/.ssh/config"; then
    log_info "Sauvegarde de ~/.ssh/config vers ~/.ssh/config.bak"
    cp "$HOME/.ssh/config" "$HOME/.ssh/config.bak"
    echo -e "Include ~/.ssh/config.d/*.conf\n\n$(cat $HOME/.ssh/config)" > "$HOME/.ssh/config"
fi

log_success "SSH multi-comptes configuré avec succès pour 3 identités."
