# Créer un dossier et y entrer
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Initialisation de direnv
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# Initialisation de zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Raccourcis fzf : Ctrl+T (fichiers) et Alt+C (répertoires).
# Atuin est chargé ensuite afin de conserver Ctrl+R pour son historique.
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# Initialisation d'Atuin
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi
