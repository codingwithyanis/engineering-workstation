# Remplacement de ls, cat et tree par les équivalents Rust modernes
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias tree='eza --tree --icons'
fi

if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
fi

# Alias zoxide sécurisé (ne détruit PAS 'cd')
if command -v zoxide >/dev/null 2>&1; then
    alias c='z'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
