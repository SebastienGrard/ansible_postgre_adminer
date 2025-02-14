# Déploiement d'un Conteneur Debian avec Ansible et Adminer  

## 📌 Prérequis  

- **Système d'exploitation** : Linux  
- **Docker** : installé et configuré (cf. [site officiel](https://www.docker.com/))  

## 🚀 Démarrage  

### 1⃣ Construction et exécution du conteneur  

Exécute les commandes suivantes :  

```sh
docker build -f Dockerfile.Debian -t debian:2.0 .
docker run -dti --name Debiantest -p 55422:22 -p 8080:80 debian:2.0
```

- Les informations du conteneur sont renseignées dans le fichier `inventory/hosts`.  
- L'utilisateur qui travaillera sur le conteneur est **"ansible"**.  

### 2⃣ Vérification d'Ansible  

Assure-toi qu'Ansible est bien installé sur le serveur en exécutant :  

```sh
ansible --version
```

### 3⃣ Création de l'utilisateur **ansible** dans le conteneur  

Entre dans le conteneur avec :  

```sh
docker exec -it <CONTAINER_ID> /bin/bash
``` 

### 4⃣ Configuration SSH dans le conteneur  

Installe et configure SSH SI CE N'EST PAS INSTALLE sur le container :  

```sh
apt update
apt install -y ssh
/etc/init.d/ssh restart
```

### 5⃣ Ajout des utilisateurs sudoers  

Ajoute **ansible** dans les sudoers :  

```sh
visudo
useradd -m -s /bin/bash ansible
passwd ansible
```

Dans le fichier qui s'ouvre, ajoute les lignes suivantes :  

```
ansible ALL=(ALL) NOPASSWD:ALL
```

### 6⃣ Transfert de la clé SSH  

Sur le client, exécute :  

```sh
ssh-copy-id -i ~/.ssh/id_ecdsa.pub -p 55422 ansible@localhost
```

### 7⃣ Vérification de la connexion Ansible  

Teste la connexion avec la commande :  

```sh
ansible -i inventory/hosts <CONTAINER_NAME> -m ping -u ansible
```

---

## 📝 Utilisation du playbook `deploy_project.yml`  

### 🔹 Exécution avec des tags  

Pour exécuter un service spécifique, utilise :  

```sh
ansible-playbook deploy_project.yml -t "NOM_DU_TAG"
```

Tags disponibles :  

| Tag       | Service installé |
|-----------|-----------------|
| `Update`  | Mise à jour du système |
| `Apache2` | Installation d'Apache |
| `MariaDB` | Installation de MariaDB |
| `DumpSQL` | Sauvegarde d'une base de données |
| `Adminer` | Installation d'Adminer |

---

## 🛠 Test d'Adminer  

Dans le conteneur, exécute :  

```sh
curl http://localhost/adminer.php
```

Si tout est bien configuré, Adminer doit être accessible via le serveur :  

```
http://localhost/adminer.php:8080
```
Le site internet via Apache2 :
```
http://localhost:8080
```

