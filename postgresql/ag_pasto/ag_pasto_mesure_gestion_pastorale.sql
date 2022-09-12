create view paec.ag_pasto_mesure_gestion_pastorale as
select mesure.id,
    mesure.maec,
    mesure.type_mesure_gestion,
    mesure.mesure,
    mesure.commentaire,
    cache.geom,
    cache.surface,
    cache.id_st,
    cache.coeur,
    cache.aire_adhesion,
    cache.aire_optimale_adhesion
from ag_pasto.c_mesure_gestion_pastorale_meg mesure
    join paec.ag_pasto_mesure_gestion_pastorale_cache cache using(id);