#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

log_header "Phase 4.1 - Installation de mise"

ensure_dir "$HOME/.local/bin"

if ! command -v mise &>/dev/null; then
    log_info "Téléchargement du binaire mise..."
    curl https://mise.run | sh
    log_success "mise installé dans ~/.local/bin/mise"
else
    log_info "mise déjà présent : $(mise --version)"
fi

ZSH_CONF_DIR="$HOME/.config/zsh/conf.d"
ensure_dir "$ZSH_CONF_DIR"

log_info "Configuration de l'activation Zsh..."

cat <<'EOF' > "$ZSH_CONF_DIR/50-mise.zsh"
# Activation automatique de mise
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
elif [ -f "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate zsh)"
fi
EOF

log_success "Intégration Zsh configurée."
