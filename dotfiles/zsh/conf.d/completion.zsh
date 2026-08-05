# Complétion avancée Zsh avec cache
autoload -Uz compinit
if [ $(date +'%j') != $(stat -c '%y' ~/.zcompdump 2>/dev/null | date +'%j') ]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Couleurs dans la complétion
zstyle ':completion:*' menu select                          # Menu interactif
