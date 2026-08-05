# Fichier .zshrc Maître - Charge automatiquement tous les modules de conf.d/
export ZDOTDIR="$HOME/.config/zsh"

for file in "$ZDOTDIR"/conf.d/*.zsh; do
    [ -r "$file" ] && source "$file"
done
