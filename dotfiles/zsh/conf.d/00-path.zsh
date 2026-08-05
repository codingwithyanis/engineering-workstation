# Définition ordonnée du PATH
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.atuin/bin"
    $path
)
export PATH
