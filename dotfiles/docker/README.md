# Docker local

Chaque projet peut gérer ses services Docker dans son propre dossier, avec son propre `docker-compose.yml` et son propre `.env` — pas un seul fichier monolithique pour toute la machine.

## Convention

- **`<projet>/docker-compose.yml` + `<projet>/.env`** : définition et configuration du service, démarrable/arrêtable indépendamment des autres.
- **`<projet>/volumes/<service>/`** : données persistantes en bind-mount (bases de données, configs générées...). Toujours un bind-mount sur le disque, jamais un volume Docker nommé — pour rester inspectable et sauvegardable directement.
- **Réseau partagé `infra`** (créé une fois par `scripts/phase5-docker/config-docker.sh`, référencé en `external: true` dans chaque compose) : permet à un service de joindre un autre par son nom de conteneur (ex : une app peut atteindre `postgres:5432`) sans dépendance de démarrage entre services.

## Démarrer un service

```bash
cd ~/Workspace/personal/projects/mon-projet
docker compose up -d
```

## Ajouter un nouveau service

Copie `docker-compose.yml.example` dans le dossier du projet, adapte l'image et les variables, et pointe le volume vers `./volumes/<service>/`.
