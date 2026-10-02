#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/user.conf"
source "$SCRIPT_DIR/../../config/versions.conf"

log_header "Phase 3.5 - Validation de la Configuration Multi-Identités"

ERRORS=0

# 0. Vérification des versions des outils Git
log_info "--- 0. Vérification des outils Git ---"
check_version() {
    local command_name="$1"
    local expected="$2"
    local actual="$3"

    if ! command_exists "$command_name"; then
        log_error "Outil manquant : $command_name"
        ERRORS=$((ERRORS + 1))
    elif [ "$actual" != "$expected" ]; then
        log_error "$command_name : version $actual détectée, version $expected requise"
        ERRORS=$((ERRORS + 1))
    else
        log_success "$command_name : version $expected"
    fi
}

DELTA_ACTUAL=""
LAZYGIT_ACTUAL=""
if command_exists delta; then
    DELTA_ACTUAL="$(delta --version 2>/dev/null | sed -n 's/^delta \([0-9][0-9.]*\).*/\1/p' | head -n 1)"
fi
if command_exists lazygit; then
    LAZYGIT_ACTUAL="$(lazygit --version 2>/dev/null | sed -n 's/.*version=\([0-9][0-9.]*\).*/\1/p' | head -n 1)"
fi
check_version "delta" "$DELTA_VERSION" "$DELTA_ACTUAL"
check_version "lazygit" "$LAZYGIT_VERSION" "$LAZYGIT_ACTUAL"

# 1. Vérification des clés SSH
log_info "--- 1. Vérification des clés SSH ---"
for key in "id_ed25519_personal" "id_ed25519_work"; do
    if [ -f "$HOME/.ssh/$key" ]; then
        log_success "Clé SSH trouvée : ~/.ssh/$key"
    else
        log_error "Clé SSH manquante : ~/.ssh/$key"
        ERRORS=$((ERRORS + 1))
    fi
done

# 2. Vérification de la structure SSH Include
log_info "--- 2. Vérification de ~/.ssh/config & config.d ---"
if [ -f "$HOME/.ssh/config.d/github.conf" ]; then
    log_success "Dossier modulaire SSH prêt : ~/.ssh/config.d/github.conf présent"
else
    log_error "Fichier ~/.ssh/config.d/github.conf introuvable !"
    ERRORS=$((ERRORS + 1))
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
        log_error "$dir => Attendu: $expected_email | Reçu: $actual_email"
        ERRORS=$((ERRORS + 1))
    fi
}

check_git_identity "$HOME/Workspace/personal" "$PERSONAL_EMAIL"
check_git_identity "$HOME/Workspace/work" "$WORK_EMAIL"
check_git_identity "$HOME/Workspace/labs" "$PERSONAL_EMAIL"

# 4. Vérification de la signature SSH des commits
log_info "--- 4. Vérification de la signature SSH ---"
EXPECTED_GITCONFIG="$(cd "$SCRIPT_DIR/../../dotfiles/git" && pwd)/gitconfig"
if [ "$(readlink -f "$HOME/.gitconfig")" = "$EXPECTED_GITCONFIG" ]; then
    log_success "~/.gitconfig correctement symlinké (SSOT)"
else
    log_error "~/.gitconfig n'est pas symlinké vers dotfiles/git/gitconfig !"
    ERRORS=$((ERRORS + 1))
fi
if [ -f "$HOME/.ssh/allowed_signers" ]; then
    log_success "~/.ssh/allowed_signers présent (vérification locale des signatures)"
else
    log_error "~/.ssh/allowed_signers manquant !"
    ERRORS=$((ERRORS + 1))
fi

if [ "$ERRORS" -eq 0 ]; then
    log_success "Validation terminée !"
else
    log_error "Validation échouée avec $ERRORS erreur(s)."
    exit 1
fi
