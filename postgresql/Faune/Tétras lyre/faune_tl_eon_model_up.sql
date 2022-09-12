create or replace view paec.faune_tl_eon_model_up as
select up.*,
    cache.surface_tl,
    cache.recouvrement
from paec.ag_pasto_up up
    join paec.faune_tl_eon_model_up_cache cache using (id);