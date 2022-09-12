create or replace view paec.faune_tl_observation_up as with n as (
        select id,
            count(*) nb_obs
        from paec.faune_tl_observation_cache
        where type = 1
        group by id
    )
select up.*,
    n.nb_obs
from paec.ag_pasto_up up
    join n using (id);