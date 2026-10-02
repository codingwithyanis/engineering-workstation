# Environnement, historique, raccourcis et fonctions de base

# PATH ordonné et dédoublonné
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.atuin/bin"
    $path
)

export PATH

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Homebrew, lorsqu'il est installé
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# Variables d'environnement
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export DO_NOT_TRACK=1
export NEXT_TELEMETRY_DISABLED=1

if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export VISUAL="nvim"
else
    export EDITOR="vim"
    export VISUAL="vim"
fi

# Historique Zsh
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Raccourcis clavier
bindkey -e
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Fonctions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Alias modulaires
for alias_file in "${ZDOTDIR:-$HOME/.config/zsh}"/aliases/*.zsh; do
    [ -r "$alias_file" ] && source "$alias_file"
done

# Complétion Zsh
if [[ -d "$HOME/.cache/antidote/github.com/zsh-users/zsh-completions/src" ]]; then
    fpath+=( "$HOME/.cache/antidote/github.com/zsh-users/zsh-completions/src" )
fi

autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -c '%y' ~/.zcompdump 2>/dev/null | date +'%j')" ]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
