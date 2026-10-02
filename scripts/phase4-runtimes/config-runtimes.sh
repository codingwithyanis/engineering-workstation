#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../config/versions.env"

log_header "Phase 4.2 - Génération de ~/.config/mise/config.toml"

MISE_CONFIG_DIR="$HOME/.config/mise"
mkdir -p "$MISE_CONFIG_DIR"

log_info "Écriture de la configuration déclarative à partir de versions.env..."

cat <<CONFIG > "$MISE_CONFIG_DIR/config.toml"
[tools]
node = "$NODE_VERSION"
pnpm = "$PNPM_VERSION"
bun = "$BUN_VERSION"

java = [
    "$JAVA_LTS",
    "$JAVA_CURRENT"
]
maven = "$MAVEN_VERSION"
gradle = "$GRADLE_VERSION"

python = "$PYTHON_VERSION"
uv = "$UV_VERSION"
php = [
    "$PHP_LTS",
    "$PHP_CURRENT"
]
composer = "$COMPOSER_VERSION"

[settings]
experimental = true
jobs = 4
raw = false
idiomatic_version_file = true
CONFIG

log_success "Fichier ~/.config/mise/config.toml généré avec succès !"
