#!/usr/bin/env bash
# lib/common.sh - Fonctions réutilisables pour Engineering Workstation

set -euo pipefail

# Styles et Couleurs
COLOR_RESET="\033[0m"
COLOR_INFO="\033[1;34m"    # Bleu
COLOR_SUCCESS="\033[1;32m" # Vert
COLOR_WARN="\033[1;33m"    # Jaune
COLOR_ERROR="\033[1;31m"   # Rouge
COLOR_HEADER="\033[1;35m"  # Magenta

log_info() {
    echo -e "${COLOR_INFO}[INFO]${COLOR_RESET} $1"
}

log_success() {
    echo -e "${COLOR_SUCCESS}[SUCCESS]${COLOR_RESET} $1"
}

log_warn() {
    echo -e "${COLOR_WARN}[WARN]${COLOR_RESET} $1"
}

log_error() {
    echo -e "${COLOR_ERROR}[ERROR]${COLOR_RESET} $1"
}

log_header() {
    echo -e "\n${COLOR_HEADER}==================================================${COLOR_RESET}"
    echo -e "${COLOR_HEADER} $1${COLOR_RESET}"
    echo -e "${COLOR_HEADER}==================================================${COLOR_RESET}\n"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

require_sudo() {
    if [ "$EUID" -ne 0 ]; then
        log_error "Ce script nécessite des privilèges root (exécute-le avec sudo)."
        exit 1
    fi
}

ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        log_info "Dossier créé : $1"
    fi
}
