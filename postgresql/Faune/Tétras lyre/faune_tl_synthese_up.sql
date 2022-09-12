create or replace view paec.faune_tl_synthese_up as with eon as (
        select id,
            'eon' as source
        from paec.faune_tl_eon_model_up
        where recouvrement > 0.1
    ),
    geonature as (
        select id,
            'geonature' as source
        from paec.faune_tl_observation_up
        where nb_obs > 1
    ),
    selection as (
        select id,
            array_agg(source) sources
        from (
                select *
                from eon
                union all
                select *
                from geonature
            ) sources
        group by id
    )
select up.*,
    sources,
    1 as score
from paec.ag_pasto_up up
    join selection using(id);