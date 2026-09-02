# Ce plugin doit être chargé après le prompt et tous les widgets ZLE.
if [[ -r "$HOME/.cache/antidote/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]]; then
    source "$HOME/.cache/antidote/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi
