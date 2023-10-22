# Installation du serveur VPS client.

Suivre le tutoriel d'installation du serveur VPS de base

## Préparation de la stack wireguard client

- Dans le Home de votre utilisateur docker creez un dossier pour la stack client
  
```bash
mkdir wireguard_stack
cd wireguard_stack
```

- Copiez le fichier `docker-compose.yml` dans le dossier `wireguard_stack`

```bash
curl -o compose.yml https://raw.githubusercontent.com/LimeDrive/plex_wg_stack/master/deploy/lsio-wireguard/client/wg-plex-client-compose.yml
```

- Créez la structure de dossier pour les fichiers de configuration Wireguard

```bash
mkdir -p {config/wireguard,scripts}
```

- Copier les script du dépot

```bash
cd scripts && \
curl -s https://api.github.com/repos/LimeDrive/plex_wg_stack/contents/scripts/wgserver | \
  grep -o 'https://raw.githubusercontent.com[^"]*' | \
  xargs -n 1 curl -LO && \
cd ..
```

- Créez le fichier `.env` et ajoutez les variables suivantes:

```bash
XID='1000' # (1)
TZ='Europe/Paris' # (2)
WIREGUARD_TAG='latest' # (3)
```

1. `XID` est l'ID de votre utilisateur docker. Vous pouvez le trouver en tapant `id -u` dans le terminal.
2. `TZ` est le fuseau horaire de votre serveur. Vous pouvez trouver la liste des fuseaux horaires disponibles [ici](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
3. `WIREGUARD_TAG` est la version de l'image Wireguard à utiliser. Vous pouvez trouver la liste des versions disponibles [ici](https://hub.docker.com/r/linuxserver/wireguard/tags).

!!! sucsess "Validation"

    Vous devriez avoir une structure de dossier comme celle-ci:

    ```bash
    wireguard_stack
        |-- compose.yml
        |-- config
        |   `-- wireguard
        `-- scripts
            |-- ForwardDown.sh
            |-- ForwardUp.sh
            |-- PostUp.sh
            `-- PreDown.sh

        3 directories, 5 files
    ```



