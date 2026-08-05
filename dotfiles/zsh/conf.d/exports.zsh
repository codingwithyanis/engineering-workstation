# Environnement standard pour ingénieur
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Éditeur par défaut
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export VISUAL="nvim"
else
    export EDITOR="vim"
    export VISUAL="vim"
fi

# Opt-out télémétrie
export DO_NOT_TRACK=1
export NEXT_TELEMETRY_DISABLED=1
