# Chargement d'Antidote
ANTIDOTE_DIR="${ZDOTDIR:-$HOME}/.antidote"
if [ -d "$ANTIDOTE_DIR" ]; then
    source "$ANTIDOTE_DIR/antidote.zsh"
    antidote load "${ZDOTDIR:-$HOME/.config/zsh}/plugins.txt"
fi
