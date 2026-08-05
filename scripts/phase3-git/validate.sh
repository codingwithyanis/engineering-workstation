#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/user.conf"

log_header "Phase 3.5 - Validation de la Configuration Multi-Identités"

# 1. Vérification des clés SSH
log_info "--- 1. Vérification des clés SSH ---"
for key in "id_ed25519_personal" "id_ed25519_personal_sys" "id_ed25519_work"; do
    if [ -f "$HOME/.ssh/$key" ]; then
        log_success "Clé SSH trouvée : ~/.ssh/$key"
    else
        log_info "[ATTENTION] Clé SSH manquante : ~/.ssh/$key"
    fi
done

# 2. Vérification de la structure SSH Include
log_info "--- 2. Vérification de ~/.ssh/config & config.d ---"
if [ -f "$HOME/.ssh/config.d/github.conf" ]; then
    log_success "Dossier modulaire SSH prêt : ~/.ssh/config.d/github.conf présent"
else
    log_info "[ATTENTION] Fichier ~/.ssh/config.d/github.conf introuvable !"
fi

# 3. Test de résolution des identités Git par dossier
log_info "--- 3. Test de résolution Git includeIf ---"

check_git_identity() {
    local dir="$1"
    local expected_email="$2"
    
    ensure_dir "$dir"
    
    # Création temporaire d'un dépôt git pour forcer l'évaluation de includeIf
    local is_temp_repo=0
    if [ ! -d "$dir/.git" ]; then
        git -C "$dir" init --quiet
        is_temp_repo=1
    fi
    
    local actual_email
    actual_email=$(git -C "$dir" config user.email || echo "NON DÉFINI")
    
    # Nettoyage du dépôt temporaire
    if [ "$is_temp_repo" -eq 1 ]; then
        rm -rf "$dir/.git"
    fi
    
    if [ "$actual_email" = "$expected_email" ]; then
        log_success "OK: $dir => Email : $actual_email"
    else
        log_info "[ERREUR] $dir => Attendu: $expected_email | Reçu: $actual_email"
    fi
}

check_git_identity "$HOME/Workspace/personal" "$PERSONAL_EMAIL"
check_git_identity "$HOME/Workspace/sys" "$PERSONAL_EMAIL_2"
check_git_identity "$HOME/Workspace/work" "$WORK_EMAIL"

log_success "Validation terminée !"
