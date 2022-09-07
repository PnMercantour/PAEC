# Enjeu Entomo

## Espèces entomo à enjeu sensibles aux pratiques agropastorales

Table `ag_pasto.tr_entomo_enjeu` filtrée pour les besoins du paec par la vue `paec.faune_entomo_especes_sensibles` (les espèces qui ne sont sensibles qu'au brûlage dirigé sont exclues).

L'attribut cd_ref est interprété suivant taxref v15. La table ag_pasto.tr_entomo_taxref donne la correspondance cd_nom cd_ref (on ne peut pas utiliser le taxref disponible dans la base, qui est en v11 comme geonature).

## Relation entre territoires agropasto, espèces et observations entomo

Des vues matérialisées calculent les relations entre territoires agropasto, espèces et observations entomo.  
Les vues matérialisées sont `paec.faune_entomo_geo_up`, `paec.faune_entomo_geo_prairie` et `paec.faune_entomo_geo_prairie_04`.  
Les vues sont construites avant filtrage des espèces ou de la date d'observation.

### Structure des vues matérialisées

- id (du territoire agropasto)
- cd_ref (de l'espèce entomo observée)
- id_synthese (observation)
- proximite (distance entre localisation de l'observation et territoire si distance inférieure à 200m)

## Synthèse par territoire agropasto

Un filtre est appliqué sur les données avant fusion:

- espèces retenues dans la vue `paec.faune_entomo_especes_sensibles`
- observations postérieures à l'an 2000
- proximité inférieure à 100m

Les vues de synthèse (une par type de territoire) donnent pour chaque territoire:

- les attributs du territoire
- le nombre d'espèces à enjeu majeur sur le territoire
- le nombre d'espèces à enjeu fort
- le nombre d'espèces à enjeu assez fort
- la valeur max rencontrée pour chacun des attributs de sensibilité
