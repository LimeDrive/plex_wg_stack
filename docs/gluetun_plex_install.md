# Installations de Plex sous VPN avec Gluetun

Ce guide explique comment installer Plex sous VPN avec Gluetun. En utilisant un VPN gratuit : [ProtonVPN](https://protonvpn.com/).

## Cree un compte ProtonVPN et recuperer les identifiants d'openvpn gratuit

1. Creer un compte ProtonVPN [ici](https://account.protonvpn.com/signup)
2. Recuperer les identifiants d'openvpn gratuit [ici](https://account.proton.me/u/0/vpn/OpenVpnIKEv2)

##  Installation pour les utilisateurs de SSD


> [!WARNING]
> Veillez à bien remplacer les variables par les votres. Chaque installation est unique donc bien verifier les chemins et les ports. ** Surtout stopper votre ancien container plex **


1. Creer un dossier pour la stack Plex

```bash
mkdir -p /home/$USER/plex_vpn
```

2. Se placer dans le dossier

```bash
cd /home/$USER/plex_vpn
```

3. Telecharger le fichier docker-compose.yml depuis le depot


```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/LimeDrive/plex_wg_stack/master/deploy/gluetun/compose.yml
```

4. Crée et editer le fichier .env

```bash
touch .env && nano .env
```
---
```ini
XID=1000
GLUETUN_TAG='latest'
PLEX_TAG='latest'
TZ='Europe/Paris'
DOMAIN='plex.example.com'
PATH_PLEX_CONFIG='/home/$USER/check/path/plex/config/on/host'
OPENVPN_USER='protonvpn_username'
OPENVPN_PASSWORD='protonvpn_password'
```
---

`ctrl` + `x` pour quitter et `y` pour sauvegarder

---

5. Lancer la stack

```bash
docker compose up -d
```

6. Verifier que tout est ok

```bash
docker exec plex curl -sSL https://ipv4.icanhazip.com
```

> [!NOTE] 
> Vous devriez voir l'ip de votre VPN et non celle de votre serveur.