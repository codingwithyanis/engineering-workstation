#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

# Inclusion explicite de tous les chemins d'exécutables installés
export PATH="$HOME/.atuin/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

log_header "Phase 2.8 - Audit de Validation Strict & Benchmark Shell"

ERRORS=0

# 1. Control Symlinks
log_info "Contrôle des liens symboliques..."
if [ "$(readlink "$HOME/.zshrc")" = "$HOME/.config/zsh/.zshrc" ]; then
    log_success "Link ~/.zshrc valide."
else
    log_error "Link ~/.zshrc invalide !"
    ERRORS=$((ERRORS + 1))
fi

# 2. Control Binaries
log_info "Contrôle de la disponibilité des binaires..."
TOOLS=(zsh starship zoxide eza bat rg fd btop atuin direnv nvim herdr)
for tool in "${TOOLS[@]}"; do
    if command_exists "$tool"; then
        log_success "Binaire OK : $tool"
    else
        log_error "Binaire manquant : $tool"
        ERRORS=$((ERRORS + 1))
    fi
done

# 3. Benchmark
log_info "Mesure de la latence au démarrage de Zsh..."
START_TIME=$(date +%s%N)
zsh -i -c exit
END_TIME=$(date +%s%N)

ELAPSED_MS=$(( (END_TIME - START_TIME) / 1000000 ))
log_info "Temps de chargement du Shell : ${ELAPSED_MS} ms"

if [ $ERRORS -eq 0 ]; then
    log_success "PHASE 2 VALIDÉE AVEC SUCCÈS ! Tous les outils sont opérationnels."
else
    log_error "Validation ÉCHOUÉE : $ERRORS outil(s) manquant(s) ou mal configuré(s)."
    exit 1
fi
