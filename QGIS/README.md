# Accéder au projet PAEC avec QGIS ou en SQL

Le projet est hébergé sur le serveur postgresql accessible par le service `projets`: schéma paec / projet PAEC.

Les couches individuelles du projet peuvent être récupérées en ouvrant le projet et en sauvegardant le ou les fichiers de description des couches, qu'il suffit ensuite de réimporter dans votre projet.  
Des relations sont établies entre certaines couches, par exemple le lien entre les prairies04 et leur exploitant. Les relations doivent être restaurées par la fonction Projet/Propriétés/Relations. Découvrir et importer les relations utiles. Cette étape n'est pas nécessaire si vous utilisez le projet PAEC comme point de départ.

Les tables sont enregistrées dans le schéma paec. Des relations sont établies avec d'autres tables du même serveur :

- schéma ag_pasto qui est une réplication récente du schéma encore en production sur le service `mercantour`

- schéma gn_synthese qui est une réplication mise à jour quotidiennement de la base de données geonature.

## Prairies

Prairies du schéma ag_pasto avec mention du service territorial (id_st) compétent.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/prairie.sql)

Des données très récentes relatives aux prairies des Alpes de Haute Provence sont également disponibles, avec les coordonnées des exploitants.  
Il s'agit des tables paec.prairie_04 et paec.exploitant_04 (service `projets`).

## Unités pastorales

Unités pastorales du schéma ag_pasto avec mention du service territorial (id_st) compétent.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/up.sql)

## MAEC

Les requêtes suivantes permettent de visualiser les mesures de gestion mises en oeuvre lors du PAEC précédent.

[Gestion des prés de fauche](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/mesure_fauche.sql)

[Gestion du pastoralisme](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/mesure_gestion_pastorale.sql)

## Flore

La liste des espèces remarquables est enregistrée dans la table paec.enjeu_flore. Cette table peut être chargée dans QGIS (avec affichage du nom valide des espèces de la liste).  
L'attribut cd_ref dénote l'espèce.  
L'attribut booléen enjeu_espece indique si l'espèce est à enjeu.  
L'attribut booléen enjeu_habitat indique si l'espèce est caractéristique d'un habitat à enjeu.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/flore_especes_remarquables.sql)

### Observations (geonature)

Observations détaillées postérieures à 1990 d'espèces de la liste paec.enjeu_flore.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/flore_observations.sql)

## [flore_prairie_vm.sql](flore_prairie_vm.sql)

Vue matérialisée (opération coûteuse) précalculée donnant la matrice de proximité prairie / taxon lorsque le taxon a été vu depuis 1990 à moins de 200m de la prairie.

Les attributs de la table sont id (prairie), cd_ref (taxon), proximite (distance en mètres entre le taxon et la prairie).  
Une jointure est nécessaire (voir plus bas les requêtes prêtes à l'emploi) pour accéder à la géométrie de la prairie ou aux données du taxon.

Il est possible de filtrer les relations en indiquant une distance inférieure à 200m, par contre les observations distantes de plus de 200m ne peuvent être obtenues avec cette requête où celles qui en dépendent (construire si besoin une requête ou une vue personnalisée en s'inspirant du [code](flore_prairie_vm.sql).

Exemples de filtrage utilisable sur la requête ou les requêtes dérivées:

    select * from paec.flore_prairie_vm where proximite <= 50;

sélectionne les triplets (prairie, taxon, proximite) dont la distance(prairie, taxon) est inférieure ou égale à 50m.

    select * from paec.flore_prairie_vm where proximite <= 50;

sélectionne les triplets (prairie, taxon, proximite) pour lesquels le taxon a été observé sur l'emprise de la prairie.

## [flore_up_vm.sql](flore_up_vm.sql)

Vue matérialisée. Fonctionnement identique à flore_prairie_vm, appliqué aux unités pastorales.

## [flore_prairie.sql](flore_prairie.sql)

Prairies pour lesquelles un taxon remarquable a été observé à proximité (moins de 200m) depuis 1990.  
L'attribut taxons donne la liste des taxons observés, la proximité (en mètres) de chaque espèce est indiquée entre crochets.  
Filtrage possible sur les attributs id_st, proximite (la distance du taxon le plus proche dans la liste), variete (nombre d'espèces observées dans la limite des 200m).

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/flore_prairie.sql)

## [flore_up.sql](flore_up.sql)

Fonctionnement identique à flore_prairie.sql, appliqué aux unités pastorales.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/flore_up.sql)

## [flore_prairie_detail.sql](flore_prairie_detail.sql)

Prairies (avec id, geom, id_st) et observations rattachées (proximite, cd_ref, nom_valide, enjeu_espece, enjeu_habitat).  
Cette requête est conçue pour être filtrée sur l'un de ses attributs, elle retourne une ligne pour chaque couple (prairie, taxon)).  
Le résultat de la requête flore_prairie.sql est plus synthétique (une ligne par prairie).

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/flore_prairie_detail.sql)

## [flore_up_detail.sql](flore_up_detail.sql)

Fonctionnement identique à flore_prairie_detail.sql, appliqué aux unités pastorales.

Télécharger la [requête sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/flore_up_detail.sql)

## flore_prairie_04

Idem flore_prairie, pour le jeu de données prairie_04.

Télécharger la [requête sql flore_prairie_4.sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/flore_prairie_4.sql)

Télécharger la [requête sql flore_prairie_04_detail.sql](https://raw.githubusercontent.com/PnMercantour/PAEC/master/QGIS/flore_prairie_04_detail.sql)
