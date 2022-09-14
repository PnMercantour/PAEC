CREATE OR REPLACE VIEW paec.natura2000_sites AS
select zsc.*,
    cache.id_st,
    cache.surface,
    cache.coeur,
    cache.aire_adhesion,
    cache.aire_optimale_adhesion
from ref_statut_protection.zsc
    join paec.natura2000_cache cache using (id)
where coeur > 0
    or aire_optimale_adhesion > 0;