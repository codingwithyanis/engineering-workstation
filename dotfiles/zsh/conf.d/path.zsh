# Définition ordonnée du PATH
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    $path
)
export PATH
