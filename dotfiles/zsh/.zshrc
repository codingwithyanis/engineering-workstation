# Fichier .zshrc maître
export ZDOTDIR="$HOME/.config/zsh"

for file in "$ZDOTDIR"/conf.d/*.zsh; do
    [ -r "$file" ] && source "$file"
done
