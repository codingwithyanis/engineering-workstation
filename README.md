# Engineering Workstation

Environnement de développement reproductible pour poste Ubuntu/Debian, provisionné par des scripts shell idempotents et organisés en phases.

L'objectif : partir d'une machine nue et obtenir, en une commande, un poste de travail complet — shell, outils CLI modernes, identités Git/SSH multiples, runtimes de langage versionnés et Docker — sans étape manuelle, et de façon reproductible d'une machine à l'autre.

## Philosophie

- **Le dépôt est la source de vérité (SSOT).** Les dotfiles (`dotfiles/`) sont déployés par lien symbolique vers `$HOME`, jamais copiés : modifier un fichier ici modifie l'environnement réel.
- **Idempotence.** Chaque script vérifie l'état avant d'agir (`command_exists`, tests de fichiers) : relancer le bootstrap sur une machine déjà configurée ne casse rien et ne réinstalle rien inutilement.
- **Validation, pas supposition.** Chaque phase a son propre `validate.sh` qui vérifie l'état réel du système (binaires présents, symlinks corrects, identités Git résolues...) plutôt que de supposer que l'installation a réussi.
- **Versions pinnées.** Les outils sensibles (delta, lazygit) et les runtimes (`config/versions.env`) ont des versions explicites, pas de `latest` implicite qui casse la reproductibilité dans le temps.

## Prérequis

- Ubuntu/Debian avec `apt` et un utilisateur avec accès `sudo`
- `bash`, `git`, `curl` déjà présents sur le système

## Démarrage

```bash
git clone <url-de-ce-depot> ~/engineering-workstation
cd ~/engineering-workstation

cp config/user.conf.example config/user.conf
$EDITOR config/user.conf   # renseigne tes identités (noms, emails perso/sys/travail)

./bootstrap.sh
```

`config/user.conf` contient des informations personnelles (noms, emails) et n'est **jamais** versionné (voir `.gitignore`) : chaque machine a le sien, généré depuis le template `config/user.conf.example`.

`bootstrap.sh` exécute les 5 phases dans l'ordre, en sautant celles déjà validées. Chaque phase peut aussi être rejouée manuellement, script par script, en cas de besoin de débogage.

## Les 5 phases

| Phase | Dossier | Contenu |
|---|---|---|
| 1 — Système & Fondations | `scripts/phase1/` | Audit système, mise à jour APT, dépôt de clés GPG moderne (`/etc/apt/keyrings`), paquets de compilation de base, locale UTF-8, arborescence `~/Workspace` et `~/Infrastructure` |
| 2 — Shell & Dotfiles | `scripts/phase2-shell/` | Zsh comme shell par défaut, Antidote (plugin manager), Starship (prompt), Atuin (historique), CLI modernes, Neovim (binaire officiel ≥ 0.12, requis par la config `kickstart.nvim`), herdr, déploiement des dotfiles par symlink (zsh, starship, nvim, wezterm) |
| 3 — Git, SSH & Identités | `scripts/phase3-git/` | Delta, Lazygit, GitHub CLI, 3 identités SSH ed25519 (personnelle / sys / travail) avec config modulaire, résolution automatique de l'identité Git selon le dossier de travail |
| 4 — Runtimes | `scripts/phase4-runtimes/` | `mise` comme gestionnaire de versions polyglotte, provisionnement déclaratif depuis `config/versions.env`, `tree-sitter-cli` (npm global, requis pour compiler les parsers Neovim) |
| 5 — Docker & Infrastructure | `scripts/phase5-docker/` | Docker CE, Buildx, Compose, LazyDocker, daemon tuné (BuildKit, log driver local), arborescence pour services auto-hébergés |

## Outils installés

**Shell & CLI** : zsh, Antidote, Starship, Atuin, ripgrep, fd, bat, eza, zoxide, btop, fastfetch, jq, yq, tree, direnv, fzf, herdr

**Éditeur** : Neovim (binaire officiel ≥ 0.12, requis par `vim.pack` — voir [Configuration Neovim](#configuration-neovim))

**Terminal** : WezTerm (config seule — le binaire n'est pas installé par ce dépôt, voir [Configuration WezTerm](#configuration-wezterm))

**Git & VCS** : git, delta, lazygit, gh (GitHub CLI)

**Runtimes** (via `mise`, versions dans `config/versions.env`) : Node.js, pnpm, Bun, Java (Temurin LTS + courant), Maven, Gradle, Python, uv, Rust, Go

**Infrastructure** : Docker CE, Buildx, Compose, LazyDocker

## Identités Git & SSH multiples

Trois identités (personnelle, personnelle-sys, travail) sont configurées de façon isolée :

- Trois clés SSH dédiées (`~/.ssh/id_ed25519_{personal,personal_sys,work}`), routées via `~/.ssh/config.d/github.conf` (hôtes `github-personal`, `github-sys`, `github-work`, idem GitLab).
- Trois profils Git (`~/.gitconfig-{personal,sys,work}`) sélectionnés automatiquement selon le dossier via `includeIf "gitdir:"` dans `dotfiles/git/gitconfig`.
- Il suffit de cloner un projet dans `~/Workspace/personal/`, `~/Workspace/sys/` ou `~/Workspace/work/` pour que l'identité Git correcte s'applique sans configuration manuelle.

La signature des commits se fait via clé SSH (`gpg.format = ssh`), et l'affichage des diffs passe par `delta`.

## Configuration Neovim

`dotfiles/nvim/` est basé sur [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), déployé par symlink sur `~/.config/nvim`. Un seul `init.lua` lisible de bout en bout, pas de framework opaque à contourner.

**Gestionnaire de plugins** : `vim.pack`, natif à Neovim depuis la 0.12 (pas de `lazy.nvim`). C'est pour ça que le binaire officiel est requis en Phase 2 — la version des dépôts Ubuntu (0.11) ne l'a pas.

**Thème** : `kanagawa.nvim` (variante wave), une palette sombre et contrastée.

**Langages avec LSP + complétion** :

| Langage | LSP |
|---|---|
| Java | `jdtls` |
| PHP | `intelephense` |
| TypeScript / JavaScript | `ts_ls` |
| Lua | `lua_ls` |
| HTML | `html` |

La configuration réutilise les exécutables déjà installés par Mason, sans charger Mason au démarrage. Le formatage manuel est disponible avec `<leader>fm`.

**Plugins principaux** :

| Rôle | Plugin |
|---|---|
| Thème et statusline | `kanagawa.nvim` + `lualine.nvim` |
| Navigation, recherche et explorateur | `snacks.nvim` |
| Diagnostics | `tiny-inline-diagnostic.nvim` |
| Autopairs | `nvim-autopairs` |
| Complétion | `blink.cmp` |
| Sauts rapides | `leap.nvim` |
| Coloration syntaxique | `nvim-treesitter` |

**Raccourcis principaux** : `<leader>ff` fichiers, `<leader>fg` recherche texte, `<leader>fb` buffers, `<leader>fd` diagnostics, `<leader>fe` explorateur, `<leader>fm` formatage, `gd` définition, `gr` références, `s`/`S` Leap et `<leader>lg` LazyGit.

## Configuration WezTerm

`dotfiles/wezterm/wezterm.lua`, déployé par symlink sur `~/.config/wezterm`. Le binaire WezTerm lui-même n'est pas installé par ce dépôt (pas de gestionnaire de paquets standard fiable pour tous les cas — Flatpak, binaire officiel, etc. selon la machine).

- Thème `Rosé Pine (base16)`, police `JetBrainsMono Nerd Font Mono Medium`
- Taille de police `10`, interligne `0.95`
- Fenêtre initiale de 150×45, pas d'opacité de fenêtre
- Barre d'onglets "fancy" activée, décorations de fenêtre en mode `TITLE | RESIZE`

## Structure du dépôt

```
engineering-workstation/
├── bootstrap.sh              # Point d'entrée : exécute les 5 phases
├── lib/common.sh             # Fonctions partagées (logging, helpers)
├── config/
│   ├── user.conf.example     # Template d'identité (à copier en user.conf)
│   ├── versions.conf         # Versions pinnées (delta, lazygit)
│   └── versions.env          # Versions pinnées des runtimes (mise)
├── dotfiles/                 # Déployés par symlink vers $HOME (SSOT)
│   ├── git/                  # gitconfig, gitignore global, config delta
│   ├── ssh/                  # config SSH modulaire (Include config.d/*.conf)
│   ├── starship.toml
│   ├── nvim/                 # init.lua (kickstart.nvim + vim.pack) -> ~/.config/nvim
│   ├── wezterm/              # wezterm.lua -> ~/.config/wezterm
│   └── zsh/                  # .zshrc + modules conf.d/*.zsh + alias/*.zsh
└── scripts/
    ├── phase1/ ... phase5-docker/
    └── */validate.sh         # Vérification post-installation de chaque phase
```

## Licence

MIT — voir [LICENSE](LICENSE).
