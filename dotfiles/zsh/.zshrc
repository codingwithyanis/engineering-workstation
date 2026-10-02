# Fichier .zshrc Maître - Charge automatiquement tous les modules de conf.d/
export ZDOTDIR="$HOME/.config/zsh"

for file in "$ZDOTDIR"/conf.d/*.zsh; do
    [ -r "$file" ] && source "$file"
done

# pnpm
export PNPM_HOME="/home/yanis/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
