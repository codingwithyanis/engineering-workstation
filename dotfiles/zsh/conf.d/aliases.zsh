# Inclusion automatique de tous les modules d'alias
for alias_file in "${ZDOTDIR:-$HOME/.config/zsh}"/aliases/*.zsh; do
    [ -r "$alias_file" ] && source "$alias_file"
done
