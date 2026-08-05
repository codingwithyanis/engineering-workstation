# Configuration robuste de l'historique Zsh
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY          # Partage l'historique entre sessions ouvertes
setopt HIST_IGNORE_DUPS       # Ignore les doublons consécutifs
setopt HIST_IGNORE_ALL_DUPS   # Supprime la vieille commande si réexécutée
setopt HIST_IGNORE_SPACE      # N'enregistre pas les commandes commençant par un espace
setopt HIST_REDUCE_BLANKS     # Supprime les espaces superflus
