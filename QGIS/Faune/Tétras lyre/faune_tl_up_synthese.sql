with eon as (
    select id,
        'eon' as source
    from paec.tetras_lyre_up_vm
    where recouvrement > 0.1
),
selection as (
    select up.id,
        array_agg(source) sources
    from paec.ag_pasto_up up
        join (
            select *
            from eon
        ) sources using(id)
    group by up.id
)
select up.*,
    sources
from paec.ag_pasto_up up
    join selection using(id)