# Intégrations des outils et plugins Zsh

# mise
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
elif [ -x "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# Atuin conserve Ctrl+R pour son historique
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# Prompt Starship
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Plugins Antidote : autosuggestions puis syntax highlighting en dernier
if [[ -r "$HOME/.cache/antidote/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]]; then
    source "$HOME/.cache/antidote/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fi

if [[ -r "$HOME/.cache/antidote/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]]; then
    source "$HOME/.cache/antidote/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi
