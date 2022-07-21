# PAEC Mercantour

[Guide utilisateur de l'application web](#guide-utilisateur)

[Guide utilisateur QGIS ou SQL](QGIS/README.md)

[Installation et exploitation de l'application web](#installation-et-exploitation)

## Guide utilisateur

Le bandeau sur la gauche de l'écran permet de consulter l'annuaire des exploitants et de sélectionner une prairie de fauche ou une unité pastorale.
Le ou les exploitants affichés dans l'annuaire sont utilisés comme filtre pour la recherche des unités pastorales et prairies.

La carte permet de visualiser les unités pastorales, les prairies, mais aussi les mesures de gestion, les conventions de pâturage et les vallées (en sélectionnant ces couches dans le sélecteur en haut à droite).

L'indication de la nature et des attributs des objets apparaît en les survolant.

Les unités pastorales et les prairies peuvent être sélectionnées (sélection synchronisée avec le menu de recherche).

Le bandeau de droite donne des informations détaillées sur l'objet sélectionné.

### Annuaire des exploitants

Chaque prairie est associée à un exploitant unique.

Chaque unité pastorale est associée à 0 ou n conventions de pâturage, chacune d'entre elles étant associée à un exploitant unique.

Chaque exploitant est associé à 0 ou 1 groupe d'exploitants.

La sélection d'un exploitant dans l'annuaire agit comme un filtre, masquant les prairies et unités pastorales qui ne sont pas associées à cet exploitant. Si l'exploitant appartient à un groupe d'exploitants, ce groupe est automatiquement sélectionné. Les données de l'exploitant sélectionné (et de son groupe, le cas échéant) sont affichées dans la carte annuaire.

la sélection d'un groupe d'exploitants dans l'annuaire a pour effet:

- d'afficher les données du groupe d'exploitants dans la carte annuaire,
- de masquer les exploitants qui n'appartiennent pas au groupe d'exploitants,
- de sélectionner l'exploitant lorsque le groupe ne contient qu'un seul exploitant,
- de masquer les prairies et unités pastorales qui ne sont pas associées à l'un des exploitants du groupe d'exploitants.

La désélection d'un groupe d'exploitants a pour effet d'annuler le filtrage (l'unité ou la prairie reste sélectionnée)

La désélection d'un exploitant a pour effet de filtrer sur le groupe auquel il appartient.

L'emprise de la carte est automatiquement mise à jour lorsque le filtre change de valeur.

### Rechercher

Cette section permet de rechercher une unité pastorale ou une prairie par son nom ou son identifiant. On peut soit taper une partie du nom ou de l'identifiant, soit utiliser le menu déroulant.

La sélection d'une unité pastorale ou d'une prairie entraîne le zoom sur la carte et l'affichage de détails dans le bandeau de droite.

Un seul objet peut être sélectionné (unité pastorale OU prairie)

### Carte

Les couches unités pastorales et prairies sont affichées par défaut. Un code couleur distingue les surfaces engagées de celles qui ne le sont pas.

Sélectionner en cliquant sur une unité pastorale ou une prairie. Désélectionner en cliquant à l'extérieur de l'objet.

Zoom automatique de la carte sur la sélection (ou sur l'emprise des unités pastorales et prairies d'un exploitant ou d'un groupe d'exploitants).

Les couches mesures de gestion (UP et prairies), conventions de pâturage et vallées sont désélectionnées par défaut.

Affichage du résumé de l'objet survolé.

Lorsque l'objet recherché est masqué par un objet appartenant à une autre couche, il suffit de désélectionner la couche qui fait obstacle.

### Bandeau d'information

Le bandeau en partie droite donne des détails sur l'unité pastorale ou la prairie sélectionnée.

- nom
- surface
- exploitants liés à la parcelle
- mesures de gestion portant sur la parcelle

## Installation et exploitation

### Génération des fichiers geojson

```shell
bin/getdata
```

construit les fichiers (geo)json utilisés par l'application.


### Déploiement

Le fichier [dashboard.service](dashboard.service) donne un exemple de service systemd pour le déploiement de l'application sur un serveur linux.

Le fichier est à adapter et à déposer dans le répertoire /etc/systemd/system

### Base de données

Les données sont dans les schémas ag_pasto et PAEC de la base de données PostgreSQL (service projets).

### Unités pastorales

table c_unite_pastorale_unp

299 UP

269 UP n'ont pas de MAEC associé

### Table t_maec_gestion_pastorale_mgp

table des MAEC

Chaque MAEC est associé à une unité pastorale unique.

Date de début et de fin (plusieurs MAEC peuvent être relatifs à la même UP, aux mêmes dates : avenant)

### Table c_mesure_gestion_pastorale_meg

mesures détaillées (avec geom) constituant un MAEC.

### Prairies

Table c_prairie_pra

1108 prairies

938 prairies n'ont pas de mesure de fauche associée.

### Table c_mesure_pres_fauche_mep

Ensemble des mesures de fauche (avec geom), associées à une prairie (sauf 3 exceptions), avec date de début et de fin.

6 mesures avec date de fin au 2021-12-31

198 au '2020-01-01'

2 2019-12-31

5 entre > 2014 et 2018
