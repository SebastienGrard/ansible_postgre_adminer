# Déploiement d'un Conteneur Debian avec Ansible

# UNE BRANCHE POUR POSTGRESQL, ET UNE BRANCHE POUR MARIADB


## 📌 Prérequis  

- **Système d'exploitation** : Linux  
- **Docker** : installé et configuré (cf. [site officiel](https://www.docker.com/))  

## 🚀 Démarrage  

### 1⃣ Construction et exécution du conteneur  

Exécute les commandes suivantes :  

```sh
docker build -f Dockerfile.Debian -t debian:2.0 .
docker run -dti --name Debiantest -p 55422:22 debian:2.0
```

- Les informations du conteneur sont renseignées dans le fichier `inventory/hosts`.  
- L'utilisateur par défaut qui travaillera sur le conteneur est **"ansible"**.  

### 2⃣ Vérification d'Ansible  

Assure-toi qu'Ansible est bien installé en exécutant :  

```sh
ansible --version
```

### 3⃣ Création de l'utilisateur **ansible** dans le conteneur  

Entre dans le conteneur avec :  

```sh
docker exec -it <CONTAINER_ID> /bin/bash
```

Puis, suis la documentation fournie par le formateur pour la création du compte **ansible**.  

### 4⃣ Configuration SSH dans le conteneur  

Installe et configure SSH :  

```sh
sudo apt update
sudo apt install -y ssh net-tools
/etc/init.d/ssh restart
```

### 5⃣ Ajout des utilisateurs sudoers  

Ajoute **ansible** et **postgres** dans les sudoers :  

```sh
sudo apt install -y vim
sudo visudo
```

Dans le fichier qui s'ouvre, ajoute les lignes suivantes :  

```
ansible ALL=(ALL) NOPASSWD:ALL
postgres ALL=(ALL) NOPASSWD:ALL
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
| `PostgreSQL` | Installation de PostgreSQL |
| `DumpSQL` | Importation d'une base de données |
| `Adminer` | Installation d'Adminer |

---

## 🛠 Test d'Adminer  

Dans le conteneur, exécute :  

```sh
curl http://localhost/adminer.php
```

Si tout est bien configuré, Adminer doit être accessible via :  

```
http://<IP_DU_CONTAINER>/adminer.php
```

