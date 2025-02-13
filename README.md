Avant de commancer:

Installer la collection MARIADB:

ansible-galaxy collection install community.mysql

Sur un environement LINUX avec DOCKER (cf le site Docker pour son installation), executer les commandes suivantes :

docker build -f Dockerfile.Debian -t debian:2.0 .
docker run -dti --name Debiantest -p 55422:22 debian:2.0

Les informations sur le container sont renseignées dans le fichier inventory/hosts.
L'utilisateur qui va travailler sur le container est "ansible"

Verifier l'installation d'ANSIBLE avec:
ansible --version

Une fois le container créer, il faut créer un utilisateur "ansible" dessus :
docker exec -it <CONTAINER_ID> /bin/bash

Suivre la documentation fournie par le formateur pour la création du compte "ansible" sur le container.

Pour permettre la connexion SSH:
sudo apt update
sudo apt install ssh
sudo apt install net-tools
/etc/init.d/ssh restart

Sur le client, mettre les utilisateurs suivants en sudoers en étant root:

sudo apt install vim
visudo

Dans le répertoire, ajouter ansible et postgres:
ansible ALL=(ALL) NOPASSWD:ALL
postgres ALL=(ALL) NOPASSWD:ALL


Transfert de la clé SSH depuis le serveur:
ssh-copy-id -i ~/.ssh/id_ecdsa.pub -p 55422 ansible@localhost

Vérification du ping pour le container hote:
ansible -i inventory/hosts <CONTAINER_NAME> -m ping -u ansible


Utilisation du playbook "deploy_project.yml"

Utilisation des tags suivants : 

-t "NOM DU TAG"

Update
Apache2
PostgreSQL
DumpSQL
Adminer

Chacun des tags installe un service specifique.



Test d'Adminer:
Executer sur le container: curl http://localhost/adminer.php
