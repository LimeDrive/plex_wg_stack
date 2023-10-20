# Guide d'installation d'une VPS pour WireGuard

## Introduction

Ce guide vous aidera à installer un serveur VPS pour WireGuard sous docker. 
Plusieurs fournisseurs de VPS peuvent offrire des services gratuits ou trés peu onéreux. 
Nous allons utiliser un VPS a 1,20€/mois chez [IONOS](https://www.ionos.fr/serveur-cloud) pour ce guide.

!!! tip "Conseil"

    Pour le choix du VPS, il est important de choisir un fournisseur qui offre une adresse IPv4 publique fixe et une bande passante illimitée.

## Configuration du VPS

### Se connecter au VPS

Pour se connecter au VPS, nous allons utiliser le protocole SSH.
Récupérer l'adresse IP du VPS dans l'interface de votre fournisseur.
Et le mot de passe dans le mail de confirmation ou sur l'interface selon votre fournisseur.

- Se connecter en root

```bash
ssh root@<ip>
```

Aprés avoir entré le mot de passe, vous devriez voir un message de bienvenue.

### Mettre à jour le système

```bash
apt update && apt upgrade -y
```

!!! info "Note"

    Si des message apparaissent, on valide par OK.

### Redémarrer le VPS

Redémarage du VPS pour appliquer les mises à jour. Aprés le redémarrage, il faudra se reconnecter au VPS.

```bash
reboot
```

### Changment du hostname

- Modifer hostname

```bash
hostnamectl set-hostname <hostname>
```

- Modifiez le fichier `hosts` avec le nouveau hostname

```bash
nano /etc/hosts
```

```bash
127.0.1.1 <hostame>
```

### Mettre en place une clé SSH

- Générer une clé SSH sur votre machine locale

```bash
ssh-keygen -t ed25519 -C "wireguard"
```

- Copier la clé publique sur le VPS

```bash
ssh-copy-id root@<ip>
```

- Se connecter au VPS avec la clé SSH

```bash
ssh root@<ip>
```

### Installation de zsh et oh-my-zsh

- Installer zsh

```bash
apt install zsh -y
```

- Installer oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

- Adapter le fichier `.zshrc` a votre besoin

```bash
nano ~/.zshrc
```

### Créer un utilisateur

- Créer un utilisateur

```bash
adduser <user>
```

- Ajouter l'utilisateur au groupe sudo

```bash
usermod -aG sudo <user>
```

- Mettre en place une clé SSH pour l'utilisateur

Sur la machine locale :

```bash
ssh-copy-id <user>@<ip>
```

### Configuration des ports sur le Panel IONOS

Nous allons ouvrir les ports suivants sur le panel IONOS :

- 51820/udp : WireGuard
- 443/tcp : HTTPS
- 80/tcp : HTTP
- <port-ssh>/tcp : Un port de votre choix pour SSH

### Activer le firewall sur la VPS et ouvrir les ports

- Allow les port ci-dessus avec ufw :

```bash
ufw allow 51820/udp
ufw allow 443/tcp
ufw allow 80/tcp
ufw allow <port-ssh>/tcp
```

- Activer le firewall

```bash
ufw enable
```

### Changement de la configuration SSH

- Supprimer le cloud-init de sshd

```bash
rm -rf /etc/ssh/sshd_config.d/50-cloud-init.conf
```

- Modifier le fichier de configuration SSH

```bash
nano /etc/ssh/sshd_config
```

- Modifier les lignes suivantes :

```bash
Port <port-ssh>
PermitRootLogin prohibit-password
PasswordAuthentication no
PermitEmptyPasswords no
```

- Redémarrer le service SSH

```bash
systemctl restart sshd
```

### Installation de tailscale

Suivre la documentation officielle pour l'installation de tailscale : [https://tailscale.com/kb/1085/install-debian/](https://tailscale.com/kb/1085/install-debian/)

### Installation de docker

Se connecter en user avec la nouvelle configuration SSH :

```bash
ssh -p <port-ssh> -i ~/.ssh/id_ed25519 <user>@<ip>
```

- Installer docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

- Ajouter l'utilisateur au groupe docker

```bash
sudo usermod -aG docker $USER
```

### Installation de crowdsec

Se referer à la documentation officielle pour l'installation de crowdsec : [https://doc.crowdsec.net/docs/getting_started/installation/](https://doc.crowdsec.net/docs/getting_started/installation/)