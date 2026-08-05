# Activation automatique de mise
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
elif [ -f "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate zsh)"
fi
