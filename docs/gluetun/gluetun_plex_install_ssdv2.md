# Installations de Plex sous VPN avec Gluetun

Ce guide explique comment installer Plex sous VPN avec Gluetun. En utilisant un VPN gratuit : [ProtonVPN](https://protonvpn.com/).

Il est destiné aux utilisateurs de [SSDV2](https://github.com/projetssd/ssdv2) et n'est pas supporté officiellement par le projet.

---

## Cree un compte ProtonVPN et recuperer les identifiants d'openvpn gratuit

1. Creer un compte ProtonVPN [ici](https://account.protonvpn.com/signup)
2. Recuperer les identifiants d'openvpn gratuit [ici](https://account.proton.me/u/0/vpn/OpenVpnIKEv2)

---

##  Procédure d'installation pour les utilisateurs du script SSDV2


> [!WARNING]
> Veillez à bien remplacer les variables par les votres. Chaque installation est unique donc bien verifier les chemins et les ports. **Surtout stopper votre ancien container plex**

## Prérequis

### Avoir un nom de domaine configuré pour plex sur votre serveur.

Les utlisateurs de cloudflare deveront impérativement suivre la partie 8 pour bypass le cache. Nous allons faire passer le traffic des stream par le proxy cloudflare, donc si le cache est activé vous risquez d'avoir des erreurs de lecture et un ban de leur service.

### Installer docker et docker-compose

Docker et installé par defaut sur SSDV2, mais ce n'est pas le cas de docker compose.

#### Vériier si docker-compose est installé

```bash
docker compose version
```

#### Installer docker-compose si nessessaire

```bash
apt install docker-compose-plugins
```

### Verifiez que votre ancinen container plex est bien stoppé et supprimer.

> [!NOTE]
> Inutil si vous n'aviez pas d'ancien container plex. Donc en cas de nouvelle installation.

```bash
docker inspect -f '{{.State.Status}}' plex
```

Si vous voyez `running` ou `restarting` vous devez stopper votre ancien container plex.

```bash
docker stop plex && docker rm plex
```

---

## Installation

### 1. Creer un dossier pour la stack Plex

```bash
mkdir -p /home/$USER/plex_vpn
```

### 2. Se placer dans le dossier

```bash
cd /home/$USER/plex_vpn
```

### 3. Telecharger le fichier docker-compose.yml depuis le depot


```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/LimeDrive/plex_wg_stack/master/deploy/gluetun/ssdv2-gluetun-compose.yml
```

### 4. Crée et editer le fichier .env

#### 4.1. Crée le fichier .env dans le dossier plex_vpn l'édité avec nano

```bash
touch .env && nano .env
```
---
    
#### 4.2. Remplacer les variables par les votres.

> [!NOTE]
> Vous pouvez copier coller le bloc de code ci-dessous et remplacer les variables par les votres.
>
> /!\ Les $USER sont a remplacer par votre nom d'utilisateur sur votre serveur.

```ini
XID=1000
GLUETUN_TAG='latest'
PLEX_TAG='latest'
TZ='Europe/Paris'
DOMAIN='plex.example.com'
PATH_PLEX_CONFIG='/home/$USER/check/path/plex/config/on/host'
PATH_HOME='/home/$USER'
OPENVPN_USER='protonvpn_username'
OPENVPN_PASSWORD='protonvpn_password'
```
##### 4.2.0 Explication des variables.

- `XID` : L'ID de votre utilisateur sur votre serveur

    `id -u $USER`

- `GLUETUN_TAG` : La version de gluetun que vous voulez utiliser. [Voir les versions](https://hub.docker.com/r/qmcgaw/gluetun/tags?page=1&ordering=last_updated)

    default : Vous pouvez utilisé `latest` pour la derniere version.

- `PLEX_TAG` : La version de plex que vous voulez utiliser. [Voir les versions](https://hub.docker.com/r/linuxserver/plex/tags?page=1&ordering=last_updated)

    default : Vous pouvez utilisé `latest` pour la derniere version.

- `TZ` : Le fuseau horaire de votre serveur. [Voir les fuseaux horaires](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

    default : `Europe/Paris`

- `DOMAIN` : Le nom de domaine que vous avez configuré **pour plex** sur votre serveur.

    REQUIRED : `plex.example.com`

- `PATH_PLEX_CONFIG` : Le chemin de votre dossier de configuration plex sur votre serveur.

    REQUIRED : `/home/$USER/seedbox/docker/$USER/plex/config`
    > [!NOTE]
    > Pour les utilisateurs du scripte SSDV2 :
    >
    > nouvelle install : `/home/$USER/seedbox/docker/$USER/plex/config`
    >
    > old install : `/opt/seedbox/docker/$USER/plex/config`

- `PATH_HOME` : Le chemin absolu de votre dossier home sur votre serveur.

    REQUIRED : `/home/$USER`


- `OPENVPN_USER` et `OPENVPN_PASSWORD` : Votre nom d'utilisateur et pass ProtonVPN

    REQUIRED : `1_username` et `2_password`

    ![ProtonVPN](https://imgur.com/2eFcZhg.png)

##### 4.3. Sauvegarder et quitter

`ctrl` + `x` pour quitter et `y` pour sauvegarder


### 5. Lancer la stack

```bash
docker compose up -d
```

### 6. Verifier que tout est ok.

```bash
docker exec plex curl -sSL https://ipv4.icanhazip.com
```

> [!NOTE] 
> Vous devriez voir l'ip de votre VPN et non celle de votre serveur.

### 7. Réglage de Plex.

> [!WARNING]
> Si vous faite une nouvelle installation de plex vous devez suivre la partie 10 pour claim le server. Avant de faire les réglages.

#### 7.1. Dans la section `Network` de Plex, cliquez sur `Show Advanced` et remplissez les champs comme sur l'image ci-dessous.

![Network](https://i.imgur.com/9pjchSV.png)

1. Desactivez le relais si vous le souhaiter.

2. Dans URL personnalisée, entrez l'adresse de votre serveur Plex. Entrez l'adresse complète, y compris le protocole (https) et le port (443).

    `https://plex.example.com:443`

    >[!NOTE]
    > Si vous utilisez une connection http sur de vieux appareille ( certaine TV ), entrez l'adresse IP complète en http et le port (80) - optionel.
    >
    > `https://plex.example.com:443,http://plex.example.com:80`


#### 7.2. Dans la section `Remote Access` de Plex, cliquez sur `Disable Remote Access`.
Sa nous assure que Plex ne va pas essayer de se connecter directement à votre serveur. Vous devez voir afficher `Not available outside your network` comme sur l'image ci-dessous.

![Remote Access](https://i.imgur.com/VtbbBSY.png)

### 8. Verifier les réglages de Cloudflare.

Avec cloudflare qui proxy votre domaine, vous devez vous assurer que sur le sous-domaine `plex.example.com` une regle de cache est bien appliqué.


Sur votre [dashboard cloudflare](`https://dash.cloudflare.com/`) ici :

![Cloudflare](https://i.imgur.com/RAfL6jb.png)

Dans les régles de cache, vous devez avoir une regle pour le sous-domaine `plex.example.com` visible :

![Rule](https://i.imgur.com/7jmE5UC.png)

**Si vous ne voyez pas de regle, vous devez en créer une.**

![Create Rule](https://i.imgur.com/mUpgThY.png)


![SetRule](https://i.imgur.com/YqaZbD8.png)


### 9. Optionelle : Activation de l' iGPU pour les processeurs Intel.

> [!WARNING]
> Cette partie est optionelle et ne concerne que les utilisateurs de processeurs Intel avec un iGPU.

#### 9.1. Suivre la documentation Hetzner sur le système d'exploitation de votre serveur.

Documentation Hetzner : [Enabling the iGPU on Intel Processors](https://community.hetzner.com/tutorials/howto-enable-igpu)

#### 9.2. Editer le fichier `docker-compose.yml`

Agouter les lignes suivantes dans le service `plex` :

```yaml
...
plex:
    image: plexinc/pms-docker:${PLEX_TAG:-latest}
    ...
    devices:
    - /dev/dri:/dev/dri
    volumes:
    ...
    - /dev/dri:/dev/dri
```

#### 9.3. Redemarrer le container plex

```bash
docker compose up -d plex
```

### 10. Optionelle : Claim du server pour les nouvelle installation.

Si vous n'aviez pas d'intallation plex avant, vous devez claim le server pour pouvoir l'utiliser.

> ![Note]
> La procedure est a faire en moin de 4 minutes sinon le claim token expire.
#### 10.1. Preparer la variable claim token

- Editer le fichier `docker-compose.yml` :

```bash
nano docker-compose.yml
```

- Ajouter la variable `PLEX_CLAIM` dans le service `plex` :

```yaml
...
plex:
    image: plexinc/pms-docker:${PLEX_TAG:-latest}
    ...
    environment:
    ...
    PLEX_CLAIM: 'claim-xxxxxxxxxxxxxxxxxxxx' # claim token voir 10.2 ci-dessous 
```

#### 10.2. Recuperer le claim token

Se rendre sur le site de plex [ici](https://www.plex.tv/claim/), se connecter et recuperer le claim token.

#### 10.3. Enregistrer et quitter

`ctrl` + `x` pour quitter et `y` pour sauvegarder

#### 10.4. Reconstruire et re-up le container plex

```bash
docker compose rm -s plex
```

```bash
docker compose up -d plex
```


---

enjoy !