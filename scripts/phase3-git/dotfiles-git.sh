#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/user.conf"

log_header "Phase 3.3 - Configuration Git Multi-Identités (3 Profils)"

GITCONFIG_DIR="$HOME"
DOTFILES_GIT="$(cd "$SCRIPT_DIR/../../dotfiles/git" && pwd)"

# 1. Profil 1 : Personnel (Outlook)
cat <<EOF > "$GITCONFIG_DIR/.gitconfig-personal"
[user]
    name = "$PERSONAL_NAME"
    email = $PERSONAL_EMAIL
    signingkey = ~/.ssh/id_ed25519_personal.pub
EOF

# 2. Profil 2 : Professionnel
cat <<EOF > "$GITCONFIG_DIR/.gitconfig-work"
[user]
    name = "$WORK_NAME"
    email = $WORK_EMAIL
    signingkey = ~/.ssh/id_ed25519_work.pub
EOF

log_success "Profils d'identité Personal et Work générés."

# 4. Fichier des signataires autorisés (vérification locale des commits signés SSH)
log_info "Génération de ~/.ssh/allowed_signers (vérification locale des signatures SSH)..."
{
    echo "$PERSONAL_EMAIL $(awk '{print $1, $2}' ~/.ssh/id_ed25519_personal.pub)"
    echo "$WORK_EMAIL $(awk '{print $1, $2}' ~/.ssh/id_ed25519_work.pub)"
} > "$HOME/.ssh/allowed_signers"

# 4. Le dépôt reste l'unique source de vérité : ~/.gitconfig, ~/.gitignore_global
#    et le module Delta sont déployés par lien symbolique, pas régénérés.
log_info "Déploiement de ~/.gitconfig (symlink -> $DOTFILES_GIT/gitconfig)..."
ln -sfn "$DOTFILES_GIT/gitconfig" "$GITCONFIG_DIR/.gitconfig"

log_info "Déploiement de ~/.gitignore_global (symlink -> $DOTFILES_GIT/gitignore_global)..."
ln -sfn "$DOTFILES_GIT/gitignore_global" "$GITCONFIG_DIR/.gitignore_global"

ensure_dir "$HOME/.config/git"
log_info "Déploiement de ~/.config/git/delta.gitconfig (symlink)..."
ln -sfn "$DOTFILES_GIT/delta.gitconfig" "$HOME/.config/git/delta.gitconfig"

log_success "Fichiers GitConfig configurés avec succès pour Personal et Work."
