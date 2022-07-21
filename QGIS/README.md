# Accéder au projet PAEC avec QGIS ou en SQL

Le projet est hébergé sur le serveur postgresql accessible par le service `projets`.  
Les tables sont enregistrées dans le schéma paec.

Télécharger le [projet QGIS](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/PAEC.qgz) avec toutes les couches

## Prairies

Prairies du schéma ag_pasto avec mention du service territorial (id_st) compétent.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/prairie.sql)

## Unités pastorales

Unités pastorales du schéma ag_pasto avec mention du service territorial (id_st) compétent.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/up.sql)

## Flore

### Observations (geonature)

Observations détaillées postérieures à 1990 d'espèces de la liste paec.enjeu_flore.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_observations.sql)

Télécharger la [couche QGIS](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_observations.qlr)

## [flore_prairie_vm.sql]()

Vue matérialisée (opération coûteuse) précalculée donnant la matrice de proximité prairie / taxon lorsque le taxon a été vu depuis 1990 à moins de 200m de la prairie.

Les attributs de la table sont id (prairie), cd_ref (taxon), proximite (proximité du taxon et de la prairie en mètres).  
Une jointure est nécessaire (voir plus bas les requêtes prêtes à l'emploi) pour accéder à la géométrie de la prairie ou aux données du taxon.

Il est possible de filtrer les relations en indiquant une distance inférieure à 200m, par contre les observations distantes de plus de 200m ne peuvent pas être obtenues par cet outil (construire une requête personnalisée en s'inspirant du code).

Exemples de filtrage:

    select * from paec.flore_prairie_vm where proximite <= 50;

ne conserve que les triplets (prairie, taxon, distance) dont la distance est inférieure ou égale à 50m.

    select * from paec.flore_prairie_vm where proximite <= 50;

pour ne conserver que les triplets pour lesquels le taxon a été observé sur l'emprise de la prairie.

## [flore_up_vm.sql]()

Vue matérialisée. Fonctionnement identique à flore_prairie_vm, appliqué aux unités pastorales.

## [flore_prairie.sql]()

Prairies pour lesquelles un taxon remarquable a été observé à proximité (moins de 200m) depuis 1990.  
L'attribut taxons donne la liste des taxons observés, la proximité (en mètres) de chaque espèce est indiquée entre crochets.  
Filtrage possible sur les attributs id_st, proximite (la distance du taxon le plus proche dans la liste), variete (nombre d'espèces observées dans la limite des 200m).

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_prairie.sql)

Télécharger la [couche QGIS](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_prairie.qlr)

## [flore_up.sql]()

Fonctionnement identique à flore_prairie.sql, appliqué aux unités pastorales.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_up.sql)

Télécharger la [couche QGIS](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_up.qlr)

## [flore_prairie_detail.sql]()

Prairies (avec id, geom, id_st) et observations rattachées (proximite, cd_ref, nom_valide). Cette requête est conçue pour être filtrée sur l'un de ses attributs, elle retourne une ligne pour chaque couple (prairie, taxon)).  
Le résultat de la requête flore_prairie.sql est plus synthétique (une ligne par prairie).

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_prairie_detail.sql)

Télécharger la [couche QGIS](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_prairie_detail.qlr)

## [flore_up_detail.sql]()

Fonctionnement identique à flore_prairie_detail.sql, appliqué aux unités pastorales.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_up_detail.sql)

Télécharger la [couche QGIS](https://raw.githubusercontent.com/PnMercantour/PAEC/QGIS/flore_up_detail.qlr)
