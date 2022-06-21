# PAEC Mercantour

## Guide utilisateur

Le bandeau sur la gauche de l'écran permet de consulter l'annuaire des exploitants et de sélectionner une prairie de fauche ou une unité pastorale.
Le ou les exploitants affichés dans l'annuaire sont utilisés comme filtre pour la recherche des unités pastorales et prairies.

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

## Génération des fichiers geojson

```shell
psql -f sql/up.sql -t -o assets/up.json service=mercantour
psql -f sql/prairie.sql -t -o assets/prairie.json service=mercantour
psql -f sql/vallee.sql -t -o assets/vallee.json service=mercantour
psql -f sql/exploitant.sql -t -o assets/exploitant.json service=mercantour
psql -f sql/gex.sql -t -o assets/gex.json service=mercantour
psql -f sql/convention_paturage.sql -t -o assets/convention_paturage.json service=mercantour
psql -f sql/join_conv_up.sql -t -o assets/join_conv_up.json service=mercantour
```

construit le fichier geojson des unités pastorales.

## Filtres

Filtre regroupement d'exploitants

Filtre Exploitant (la sélection d'un exploitant force le gex associé)

Filtre Service territorial

## Déploiement

Le fichier `dashboard.service` donne un exemple de service systemd pour le déploiement de l'application sur un serveur linux.

Le fichier est à adapter et à déposer dans le répertoire /etc/systemd/system

## Base de données

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
