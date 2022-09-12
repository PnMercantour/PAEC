create view paec.ag_pasto_mesure_fauche as
select id,
    geom,
    commentaire,
    prairie,
    engagement_unitaire,
    debut_contractualisation,
    fin_contractualisation,
    montant_contrat,
    pac_parcelle_engagee,
    pacage,
    avenant,
    cache.surface,
    cache.id_st,
    cache.coeur,
    cache.aire_adhesion,
    cache.aire_optimale_adhesion
from ag_pasto.c_mesure_pres_fauche_mep mesure
    join paec.ag_pasto_mesure_fauche_cache cache using(id)