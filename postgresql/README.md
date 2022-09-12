# Structure de la base de données PostgreSQL

Ce dossier contient la définition des tables, vues et vues matérialisées du schéma paec.

## Schéma paec

    alter default privileges in schema paec grant select on tables to pnm_consult, consult_agpasto, consult_eau;

## Limitations QGIS

QGIS n'identifie pas correctement les types de géométrie présents dans une vue postgresql de type geometry. On contourne le problème en créant une vue dédiée pour chaque type (et on masque la vue générique). Voir les altérations zh pour exemple.
