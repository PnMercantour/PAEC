Les requêtes `ag_pasto_*_extra` construisent des vues matérialisées qui pré-calculent les surfaces d'intersection des unités pastorales et prairies avec les limites du parc.

Les requêtes `ag_pasto_up`, `ag_pasto_prairie` et `ag_pasto_prairie_04` construisent des vues du même nom qui intègrent les données brutes agropasto, les données `extra` et l'identifiant du service territorial référent (tables up_st et prairie_st, à revoir pour automatiser l'association up-st sauf cas particuliers).

La vm ag_pasto_mesure_fauche_cache et la vue ag_pasto_maec prennent en compte les contractualisations postérieures au 1er janvier 2015, compris.

Il en va de même pour les vues qui en dépendent : ag_pasto_mesure_gestion_pastorale_cache et ag_pasto_mesure_gestion_pastorale, ainsi que ag_pasto_mesure_fauche.
